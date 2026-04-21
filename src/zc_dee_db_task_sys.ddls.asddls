@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'TASK MANAGEMENT SYSTEM'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZDEE_DB_TASK_SYS'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_DEE_DB_TASK_SYS
  provider contract transactional_query
  as projection on ZR_DEE_DB_TASK_SYS
  association [1..1] to ZR_DEE_DB_TASK_SYS as _BaseEntity on $projection.TaskID = _BaseEntity.TaskID
{

  key TaskID,
  TaskName,
  Description,
  EmployeeID,
  AssignedTo,
  StartDate,
  EndDate,
  
  @UI.lineItem: [{ position: 30 }]
@UI.identification: [{ position: 30 }]
@Consumption.valueHelpDefinition: [{
    entity: {
        name: 'ZC_DEE_STATUS',
        element: 'Status'
    }
}]
Status,
  Priority,
  
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  @Semantics: {
    user.lastChangedBy: true
  }
  LastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  _BaseEntity
}
