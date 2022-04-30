
-- 1. tblInsa. 남자 급여(기본급+수당)을 (내림차순)순위대로 가져오시오. (이름, 부서, 직위, 급여, 순위 출력)
select * from tblInsa;



select 
    name, buseo, jikwi, basicpay, rownum
from tblInsa
    where ssn like '%-1%'
    order by basicpay + sudang desc;
    
    
-- 최종    
select
    name, buseo, jikwi, salary, rownum
from(select 
    name,
    buseo, 
    jikwi, 
    (basicpay + sudang) as salary, 
    rownum
from tblInsa
    where ssn like '%-1%'
    order by basicpay + sudang desc);


-- 2. tblInsa. 여자 급여(기본급+수당)을 (오름차순)순위대로 가져오시오. (이름, 부서, 직위, 급여, 순위 출력)
select * from tblInsa;



select
    name, buseo, jikwi, salary, rownum
from(select 
    name, buseo, jikwi, (basicpay + sudang) as salary, rownum
from tblInsa
    where ssn like '%-2%'
    order by basicpay + sudang asc);



-- 3. tblInsa. 여자 인원수가 (가장 많은 부서 및 인원수) 가져오시오.
select * from tblInsa;

select
    buseo,
    count(*)
from tblInsa
    where ssn like '%-2%'
    group by buseo
    having count(*) = (select max(count(*)) from tblInsa where ssn like '%-2%'group by buseo);


--rownum을 이용해서
select buseo, cnt, rownum from
                            (select
                                buseo,
                                count(*) as cnt
                            from tblInsa
                                where substr(ssn,8,1)='2'
                                    group by buseo
                                        order by count(*) desc)
                                            where rownum = 1;

-- 4. tblInsa. 지역별 인원수 (내림차순)순위를 가져오시오.(city, 인원수)
select * from tblInsa;

-- 지역별 인원수
select
    city,
    count(*)
from tblInsa
    group by city;
    
    
    
-- 지역별 내림차순 순위
select 
    rownum "순위",
    city "지역",
    num as "인원수"             
from(select
    city,
    count(*) as num
from tblInsa
    group by city 
        order by count(*) desc);






-- 5. tblInsa. 부서별 인원수가 가장 많은 부서 및 인원수 출력.
select * from tblInsa;

--부서별 인원수
select
    buseo,
    count(*)
from tblInsa
    group by buseo;
    
    
select
    buseo,
    max
from (select
    count(*) as max
from tblInsa
    group by buseo
        having count(*) = (select
                            max(count(*))
                        from tblInsa
                            group by buseo));
                            
-- 최종
select buseo, cnt, rownum from
                            (select
                                buseo,
                                count(*) as cnt
                            from tblInsa
                                    group by buseo
                                        order by count(*) desc)
                                            where rownum = 1;

-- 6. tblInsa. 남자 급여(기본급+수당)을 (내림차순) 3~5등까지 가져오시오. (이름, 부서, 직위, 급여, 순위 출력)
select
    name, buseo, jikwi, salary, rownum as rnum
from(select 
    name,
    buseo, 
    jikwi, 
    (basicpay + sudang) as salary, 
    rownum
from tblInsa
    where ssn like '%-1%'
    order by basicpay + sudang desc);


-- 최종
select 
    name, buseo, jikwi, salary, rnum
from(select
    name, buseo, jikwi, salary, rownum as rnum
from(select 
    name,
    buseo, 
    jikwi, 
    (basicpay + sudang) as salary, 
    rownum
from tblInsa
    where ssn like '%-1%'
    order by basicpay + sudang desc))
    where rnum between 3 and 5;


-- 7. tblInsa. 입사일이 빠른 순서로 5순위까지만 가져오시오.
select * from tblInsa;


select 
    *
from tblInsa
    order by ibsadate asc;

-- 최종
select 
    rownum,
    a.*
from(select 
    *
from tblInsa
    order by ibsadate asc) a
    where rownum <= 5;


-- 8. tblhousekeeping. 지출 내역(가격 * 수량) 중 가장 많은 금액을 지출한 내역 3가지를 가져오시오.
select * from tblhousekeeping;


select
    price * qty as "지출 내역",
    item
from tblhousekeeping
    order by price * qty desc;

--최종
select 
    rownum,
    a.*,
    price * qty as "지출 내역"
from (select
    *
from tblhousekeeping
    order by price * qty desc) a
        where rownum <= 3;

-- 9. tblinsa. 평균 급여 2위인 부서에 속한 직원들을 가져오시오

select 
    buseo,
    avg(basicpay)
from tblInsa
    group by buseo
        order by avg(basicpay) desc;




-- 부서별 평균 급여 내림차순
select buseo, avg(basicpay) from tblInsa group by buseo order by avg(basicpay) desc;

--
select buseo, avgbasicpay, rownum from
(select buseo, avg(basicpay) as avgbasicpay from tblInsa group by buseo order by avg(basicpay) desc);


select buseo from
(select buseo, avgbasicpay, rownum as rnum from
(select buseo, avg(basicpay) as avgbasicpay from tblInsa group by buseo order by avg(basicpay) desc));

-- 최종
select * from tblInsa where buseo = (select buseo from
                                            (select buseo, avgbasicpay, rownum as rnum from
                                                                                    (select buseo, avg(basicpay) as avgbasicpay from tblInsa group by buseo order by avg(basicpay) desc))where rnum =2);




-- 10. tbltodo. 등록 후 가장 빠르게 완료한 할일을 순서대로 5개 가져오시오.

select
    title,
    completedate - adddate
from tblTodo
    where completedate is not null
        order by (completedate - adddate) asc;


select title, rownum from(select
                                title,
                                completedate - adddate
                            from tblTodo
                                where completedate is not null
                                    order by (completedate - adddate) asc)
                                        where rownum <= 5;




-- 11. tblinsa. 남자 직원 중에서 급여를 3번째로 많이 받는 직원과 9번째로 많이 받는 직원의 급여 차액은 얼마인가?
select * from tblInsa;


select 
    *
from tblInsa
    where ssn like '%-1%'
        order by basicpay desc;


select
    rownum,
    a.*
from(select 
    *
from tblInsa
    where ssn like '%-1%'
        order by basicpay desc) a;

--3번째와 9번째로 많이 받는 직원의 급여
select 
    rnum,
    basicpay
from(select
    rownum as rnum,
    a.*
from(select 
    *
from tblInsa
    where ssn like '%-1%'
        order by basicpay desc) a) 
            where rnum in (3,9);



            
            
select 
    (select basicpay from (select
                                rownum as rnum,
                                basicpay
                            from(select 
                                    basicpay
                                from tblInsa
                                    where ssn like '%-1%'
                                        order by basicpay desc)) 
                                             where rnum = 3) 
     - (select basicpay from (select
                                rownum as rnum,
                                basicpay
                            from(select 
                                    basicpay
                                from tblInsa
                                    where ssn like '%-1%'
                                        order by basicpay desc)) 
                                             where rnum = 9) as "급여 차액"
from dual;
