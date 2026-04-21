@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZDEE_DB_TASK_SYS'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DEE_DB_TASK_SYS
  as select from zdee_db_task_sys
{
  key task_id as TaskID,
  task_name as TaskName,
  description as Description,
  emp_id as EmployeeID,
  assigned_to as AssignedTo,
  start_date as StartDate,
  end_date as EndDate,

  status as Status,
  priority as Priority,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
}
