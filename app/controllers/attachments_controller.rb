class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment
  before_action :verify_authorship

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def verify_authorship
    unless current_user.author_of?(@attachment.attachable)
      render :destroy
    end
  end
end
