CLASS LHC_ZR_DEE_DB_TASK_SYS DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrDeeDbTaskSys
        RESULT result,
      setInitialStatus FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrDeeDbTaskSys~setInitialStatus,
            validateDates FOR VALIDATE ON SAVE
  IMPORTING keys FOR ZrDeeDbTaskSys~validateDates.

ENDCLASS.

CLASS LHC_ZR_DEE_DB_TASK_SYS IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD setInitialStatus.
  READ ENTITIES OF ZR_DEE_DB_TASK_SYS IN LOCAL MODE
    ENTITY ZrDeeDbTaskSys
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(tasks).

  LOOP AT tasks INTO DATA(task).

    IF task-Status IS INITIAL.

      MODIFY ENTITIES OF ZR_DEE_DB_TASK_SYS IN LOCAL MODE
        ENTITY ZrDeeDbTaskSys
        UPDATE FIELDS ( status )
        WITH VALUE #(
          ( %tky   = task-%tky
            status = 'ASSIGNED' )
        ).

    ENDIF.

  ENDLOOP.

ENDMETHOD.


METHOD validateDates.

  " Read new (changed) data
  READ ENTITIES OF ZR_DEE_DB_TASK_SYS IN LOCAL MODE
    ENTITY ZrDeeDbTaskSys
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(tasks).

  " Read OLD data from database (ACTIVE data only)
  SELECT taskid, status
    FROM zr_dee_db_task_sys
    FOR ALL ENTRIES IN @tasks
    WHERE taskid = @tasks-taskid
    INTO TABLE @DATA(old_tasks).

  LOOP AT tasks INTO DATA(task).

    " 1. Date validation
    IF task-StartDate IS NOT INITIAL
       AND task-EndDate IS NOT INITIAL
       AND task-EndDate < task-StartDate.

      APPEND VALUE #( %tky = task-%tky ) TO failed-ZrDeeDbTaskSys.

      APPEND VALUE #(
        %tky = task-%tky
        %msg = new_message(
          id = 'ZMSG'
          number = '003'
          severity = if_abap_behv_message=>severity-error
          v1 = 'End Date cannot be less than Start Date'
        )
      ) TO reported-ZrDeeDbTaskSys.

    ENDIF.

    "  2. Get OLD status
    READ TABLE old_tasks INTO DATA(old_task)
      WITH KEY taskid = task-TaskID.

    "  3. Allow first time change to COMPLETED
    IF old_task-Status <> 'COMPLETED'
       AND task-Status = 'COMPLETED'.
      CONTINUE.
    ENDIF.

    "  4. Block if already COMPLETED before
    IF old_task-Status = 'COMPLETED'.

      APPEND VALUE #( %tky = task-%tky ) TO failed-ZrDeeDbTaskSys.

      APPEND VALUE #(
        %tky = task-%tky
        %msg = new_message(
          id = 'ZMSG'
          number = '002'
          severity = if_abap_behv_message=>severity-error
          v1 = 'Completed tasks cannot be edited'
        )
      ) TO reported-ZrDeeDbTaskSys.

    ENDIF.

  ENDLOOP.

ENDMETHOD.




ENDCLASS.
