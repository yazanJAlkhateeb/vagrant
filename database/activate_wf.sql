USE psysjo
GO
update JFW_WF_WORKFLOW set status=1 where name like 'WF_%';
GO
EXIT