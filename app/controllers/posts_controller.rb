class PostsController < ApplicationController
  require 'elasticsearch/es_client'
  before_filter :authenticate_user!, only: [:index,:new, :create,:edit, :update,:destroy]
  before_filter :check_role_autorization

  before_filter :set_post, only: [:edit, :update, :destroy]
  before_filter :set_post_for_show, only: [:show]
  before_filter :prepare_categories
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    #abort @post.comments.inspect
    if @post.comments!=nil
    @comment_tree= build_commentree(@post.comments.as_json)
    @commentTreeHtml=build_commentreeHtml(@comment_tree)

   end
    @comment=Comment.new
    @comment.post_id=@post.id
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])


  end

  # POST /posts
  # POST /posts.json
  def create
    #abort params[:post].inspect

    @tag=Tag.where(id:params[:post]['tags'])
    params[:post]['tags']=@tag

    @post = Post.new(params[:post])
    @post.user_id=current_user.id
    ES_Index()
#abort @post.inspect
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update

    @tag=Tag.where(id:params[:post]['tags'])
    params[:post]['tags']=@tag
    @post = Post.find(params[:id])
    ES_Index()
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    ES_Index_Delete()
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  private
  def ES_Index
    @ES_PostClient=ES_PostClient.new
    @ES_PostClient.index("sting", @post.id, @post )
  end
  def ES_Index_Delete
    begin
      @ES_PostClient=ES_PostClient.new
      @ES_PostClient.delete("sting",@post.id)
    rescue
    end
  end
  def set_post

    @post = Post.where(:id => params[:id],:user_id=>current_user.id).first
    #abort @post.inspect
  end
  def set_post_for_show
    @post = Post.find(params[:id])
  end

  def prepare_categories
    @categories = Category.order(:name)
  end
  def build_commentree(elements, parentId=nil)
    tree = Array.new
    elements.each do |element|

      if element['parent_id'] == parentId
        #abort element['id'].inspect
        element['username']=Comment.find(element['id']).user.email
        children = build_commentree(elements, element['id'])
        #abort children.inspect
        if children.any?

          element['children']=children
          #element.store(children: children)
          #element.merge('children'=>children)
          # abort element.inspect
        end

        tree.push(element)

      end
    end

    return tree

  end
  #will move in view healper
  def build_commentreeHtml(commentTree)
     #abort commentTree.inspect
    htmlTree = "<article>"
    commentTree.each do |comment|
      htmlTree+="<header><p>PostedBy:"+comment["username"].to_s+"</p><p>PostedAt:"+comment["created_at"].to_s+"</p></header>"
      htmlTree+="<p>"+comment["comment"]+"</p>"

      htmlTree+="<a href='/comments/new/"+comment['id'].to_s+"'>Reply</a>"
      if current_user.id==comment['user_id']
        htmlTree+="|<a href='/comments/"+comment['id'].to_s+"' data-method='delete'>Delete</a>"
      end
        htmlTree+="<hr/>"
      if comment["children"]
        #abort comment["children"].inspect
        htmlTree+= build_commentreeHtml(comment["children"])

      end


    end
    #abort htmlTree.inspect
    htmlTree+="</article>"

  end
end
