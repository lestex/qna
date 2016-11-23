ThinkingSphinx::Index.define :answer, with: :active_record do
  #fields
  indexes body
  indexes user.email, as: :author

  # attributes
  has question_id, user_id, created_at, updated_at
end