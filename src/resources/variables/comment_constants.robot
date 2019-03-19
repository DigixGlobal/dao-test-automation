*** Variables ***
${NUMBER_OF_THREADS}  11
${NUMBER_OF_REPLIES}  7
${NUMBER_OF_NESTED_REPLIES}  4
${REMOVE_MESSAGE}  This message has been removed by the user.
${ROUND_BTN}  button[class*="RoundBtn"]
${SORTING_DD}  css=#comment-filter
${POST_COMMENT_BTN}  button[class*="PostCommentButton"]
${THREAD_SECTION}  jquery=div[class*="ThreadedComments"]
${THREAD_FIELD}  ${THREAD_SECTION} > div > div > textarea
${THREAD_BUTTON}  css=[data-digix="Thread-Button"]
${COMMMENT_DIV}  jquery=div[class*="ParentCommentItem"]
${COMMENT_POST}  div[class*="CommentPost"]
${COMMENT_ACTION_CONTAINER}  [class*="ActionCommentButton"]
${LIKE_ICON}  div[kind="like"]
${REPLY_ICON}  div[kind="reply"]
${COMMENT_REPLY}  section.comment-reply
${COMMENT_REPLY_POST}  div
