*** Variables ***
${KYC_ADMIN_ALL_REQUEST_TAB}  css=[data-digix="Kyc-Admin-All-users"]
${KYC_ADMIN_PENDING_TAB}  css=[data-digix="Kyc-Admin-KYC-Requests"]
${KYC_ADMIN_APPROVED_TAB}  css=[data-digix="Kyc-Admin-Approved-Requests"]
${KYC_ADMIN_REJECTED_TAB}  css=[data-digix="Kyc-Admin-Rejected-Requests"]
${KYC_ADMIN_TABLE}  jquery=.rt-table
${KYC_ADMIN_ROW_DIV}  ${KYC_ADMIN_TABLE} .rt-tr-group
${KYC_ADMIN_MODAL_STATUS}  jquery=[class*="ValueWrapper"]:eq(0) > [class*="Value"]
${KYC_ADMIN_MODAL_USER_ID}  jquery=[class*="ValueWrapper"]:eq(1) > [class*="Value"]
${KYC_ADMIN_ACTION_TOGGLE}  css=[data-digix="KycAction"]
${KYC_ADMIN_REJECTION_DD}  css=[data-digix="KYC-Rejection-Reason"]
${KYC_ADMIN_EXPIRATION_FIELD}  css=[data-digix="Approve-Kyc-Expiration"]
${KYC_ADMIN_MODAL_BTN}  css=[class*="FieldGroup"] button
${CLOSE_MODAL_ICON}  css=button[class*="closeButton"]
${KYC_ADMIN_TABLE_PAGINATION_DIV}  css=.pagination-bottom