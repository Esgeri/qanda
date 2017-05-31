class Attachment < ApplicationRecord
  belongs_to :attachmentable, optional: true, polymorphic: true

  mount_uploader :file, FileUploader
end
