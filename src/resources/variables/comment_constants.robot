*** Variables ***
${NUMBER_OF_THREADS}  11
${NUMBER_OF_CHILD}  7
${ROUND_BTN}  button[class*="RoundBtn"]
${THREAD_SECTION}  jquery=div[class*="ThreadedComments"]
${THREAD_FIELD}  ${THREAD_SECTION} > div > div > textarea
${THREAD_BUTTON}  ${THREAD_SECTION} > div >  ${ROUND_BTN}
${COMMMENT_DIV}  jquery=div[class*="ParentCommentItem"]
${COMMENT_POST}  div[class*="CommentPost"]
${REPLY_ICON}  div[kind="reply"]
${COMMENT_REPLY}  section.comment-reply
${COMMENT_REPLY_POST}  div