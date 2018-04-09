class ApplicationController < ActionController::Base

  protect_from_forgery
 # before_filter :init_auth


  # def init_auth
  #
  #   case controller_name
  #     when "posts"
  #       before_filter :authenticate_user!, only: [:index,:new, :create,:edit, :update,:destroy]
  #   else
  #       "You gave me #{x} -- I have no idea what to do with that."
  #   end
  #   #abort controller_name.inspect
  #
  # end

 $acl=Hash.new
  $acl[$roles[:admin]]={
      'posts'=>{'index'=>true,'new'=>true, 'create'=>true,'edit'=>true, 'update'=>true,'destroy'=>true,'show'=>true},
      'admin'=>{'index'=>true},
      'categories'=>{'index'=>true,'new'=>true, 'create'=>true,'edit'=>true, 'update'=>true,'destroy'=>true,'show'=>true},
     'tags'=>{'index'=>true,'new'=>true, 'create'=>true,'edit'=>true, 'update'=>true,'destroy'=>true,'show'=>true},
      'comments'=>{'index'=>true,'new'=>true, 'create'=>true,'edit'=>true, 'update'=>true,'destroy'=>true,'show'=>true}
      }
  $acl[$roles[:user]]={
          'posts'=>{'index'=>true,'new'=>true, 'create'=>true,'edit'=>true, 'update'=>true,'destroy'=>true,'show'=>true},
          'categories'=>{'index'=>true,'show'=>true},
      'tags'=>{'index'=>true,'show'=>true},
          'comments'=>{'index'=>true,'new'=>true, 'create'=>true,'edit'=>true, 'update'=>true,'destroy'=>true,'show'=>true}
      }
  $acl[$roles[:guest]]={
      'posts'=>{'index'=>true,'show'=>true},
      'categories'=>{'index'=>true,'show'=>true},
  'tags'=>{'index'=>true,'show'=>true},
      'comments'=>{'index'=>true,'show'=>true}
  }

def check_role_autorization
  #abort  current_user.inspect
  #abort  $acl[current_user.role][controller_name][action_name].inspect
 if current_user.role==nil
   current_user.role=$roles[:guest]
 end

 if $acl[current_user.role]==nil||
     $acl[current_user.role][controller_name]==nil||
     $acl[current_user.role][controller_name][action_name]==nil||
     !$acl[current_user.role][controller_name][action_name]
  raise 'You have not "'+action_name+'" privilege on "'+ controller_name+'"'
  # abort $acl[current_user.role][controller_name][action_name].inspect
 end

end

  def after_sign_in_path_for(resource)
  #  abort  current_user.inspect
    if current_user.role==$roles[:admin]
      return '/admin/index'
    end
    return '/posts'
  end
end
