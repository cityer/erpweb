DELIMITER //  
CREATE PROCEDURE category_exchange_node(IN sname varchar(100), IN tname varchar(100))  
BEGIN

declare slft int;
declare srgt int;
declare swidth int;
declare tlft int;
declare trgt int;
declare twidth int;

declare diff int;
declare jiange int;

declare temp1 int;
declare temp2 int;

SELECT lft, rgt into slft, srgt FROM category WHERE name = sname;
SELECT lft, rgt into tlft, trgt FROM category WHERE name = tname;

if slft > tlft then
	set temp1 = slft + tlft;
	set slft = temp1 - slft;
	set tlft = temp1 - tlft;
	set temp2 = srgt + trgt;
	set srgt = temp2 - srgt;
	set trgt = temp2 - trgt;
end if;

update category set flag = 1 where lft >= slft and lft < tlft;

set diff = (trgt - tlft) - (srgt - slft);

update category set lft = lft + diff, rgt = rgt + diff, flag = 0 where flag = 1 and lft > srgt and rgt < tlft;

set jiange = tlft - slft;

update category set lft = lft - jiange, rgt = rgt - jiange where flag = 0 and lft between tlft and trgt;
	
update category set lft = lft + jiange + diff, rgt = rgt + jiange + diff 
where flag = 1 and lft between slft and srgt;

update category set flag = 0 where flag = 1;

END;
//  
DELIMITER ;