
/*  
	The current simple refset snapshot file is an accurate derivative of the current full file
*/

/* view of current snapshot, derived from current full */
	create or replace view temp_view as
	select a.*
	from curr_simplerefset_f a
	where cast(a.effectivetime as datetime) = 
		(select max(cast(z.effectivetime as datetime))
		 from curr_simplerefset_f z
		 where z.id = a.id);

/* in the delta; not in the full */
	insert into qa_result (runid, assertionuuid, assertiontext, details)
	select 
	<RUNID>,
	'<ASSERTIONUUID>',
	'<ASSERTIONTEXT>',
	concat('SIMPLE REFSET: id=',a.id, ': Member is in SNAPSHOT file, but not in FULL file.')
	from curr_simplerefset_s a
	left join temp_view b 
	on a.id = b.id
	and a.effectivetime = b.effectivetime
	and a.active = b.active
    and a.moduleid = b.moduleid
    and a.refsetid = b.refsetid
    and a.referencedcomponentid = b.referencedcomponentid
	where b.id is null
	or b.effectivetime is null
	or b.active is null
	or b.moduleid is null
  	or b.refsetid is null
  	or b.referencedcomponentid is null;

	commit;
	
/* in the full; not in the delta */
	insert into qa_result (runid, assertionuuid, assertiontext, details)
	select 
	<RUNID>,
	'<ASSERTIONUUID>',
	'<ASSERTIONTEXT>',
	concat('SIMPLE REFSET: id=',a.id, ': Member is in FULL file, but not in SNAPSHOT file.') 
	from temp_view a
	left join curr_simplerefset_s b 
	on a.id = b.id
	and a.effectivetime = b.effectivetime
	and a.active = b.active
    and a.moduleid = b.moduleid
    and a.refsetid = b.refsetid
    and a.referencedcomponentid = b.referencedcomponentid
	where b.id is null
	or b.effectivetime is null
	or b.active is null
	or b.moduleid is null
  	or b.refsetid is null
  	or b.referencedcomponentid is null;
	
	commit;
	drop view temp_view;






