@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status dropdown'

define view entity ZC_DEE_STATUS
  as select from ZR_DEE_DB_TASK_SYS
{
  key cast( 'ASSIGNED'        as abap.char(20) ) as Status
}
where TaskID is not null

union select from ZR_DEE_DB_TASK_SYS
{
  key cast( 'IN_PROGRESS' as abap.char(20) ) as Status
}
where TaskID is not null

union select from ZR_DEE_DB_TASK_SYS
{
  key cast( 'COMPLETED'   as abap.char(20) ) as Status
}
where TaskID is not null
