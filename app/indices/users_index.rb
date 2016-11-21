ThinkingSphinx::Index.define :user, with: :active_record do
  #fields
  indexes email

  # attributes
  has admin, created_at, updated_at
end