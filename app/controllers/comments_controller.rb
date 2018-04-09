class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:index,:new, :create,:edit, :update,:destroy]
  before_filter :check_role_autorization

  before_filter :set_comment, only: [:edit, :update, :destroy]
  before_filter :set_comment_for_show, only: [:show]
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    if params[:parent_id]!=nil
      @ParentComment = Comment.find(params[:parent_id])
      @comment.parent_id=@ParentComment.id
      @comment.post_id=@ParentComment.post_id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id=current_user.id


    respond_to do |format|
      if @comment.save
        #UserMailer.send_comment_mail(@comment.user.email,@comment.post_id).deliver
        SendCommentMailWorker.perform_async(@comment.user.email,@comment.post_id)
        format.html { redirect_to '/posts/'+@comment.post_id.to_s, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end

    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to '/posts/'+@comment.post_id.to_s }
      format.json { head :no_content }
    end
  end
  private

  def set_comment

    @comment = Comment.where(:id => params[:id],:user_id=>current_user.id).first
    #abort @post.inspect
  end
  def set_comment_for_show
    @comment = Comment.find(params[:id])
  end
end
