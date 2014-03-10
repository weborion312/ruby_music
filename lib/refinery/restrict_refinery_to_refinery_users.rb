module RestrictRefineryToRefineryUsers

  def restrict_refinery_to_refinery_users
    #current_user.try(:roles).try(:empty?) is another possibility
    return unless !current_admin_user.try(:has_role?, "Refinery")
    #this user is not a refinery user because they have no refinery roles.
    redirect_to main_app.root_path
    return false
  end

end
