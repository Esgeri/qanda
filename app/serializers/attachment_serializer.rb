class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file, :created_at, :updated_at, :attachable_id, :attachable_type, :name, :file_url

  def name
    object.file.identifier
  end

  def file_url
    object.file.url
  end
end
