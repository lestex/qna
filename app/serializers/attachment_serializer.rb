class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :created_at, :updated_at, :file_url

  def file_url
    Rails.application.config.hostname_url + object.file.url
  end
end