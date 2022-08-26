local has_Comment, Comment = pcall(require, 'Comment')
if not has_Comment then
  return
end

Comment.setup()
