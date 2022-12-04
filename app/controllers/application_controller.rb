# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protected

  def set_project
    @project = Project.find(params[:project_id])
  end

  def project_owner?
    return if @project.owner == current_user

    redirect_to root_path, alert: "You don't have access to that project."
  end
end
