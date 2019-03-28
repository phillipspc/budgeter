class Users::InvitationsController < Devise::InvitationsController
  def after_invite_path_for(resource)
    flash[:notice] = "Invitation sent"
    edit_settings_path
  end
end
