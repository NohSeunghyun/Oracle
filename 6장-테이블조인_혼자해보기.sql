--문제1. 사원번호가 '7788'인 사원의 소속된 사원번호, 사원이름, 소속부서번호, 소속부서이름 얻기

--1.equi join

select eno, ename, e.dno, dname
from employee e, department d
where e.dno=d.dno
and eno=7788;

--2.natural join

select eno, ename, dno, dname
from employee natural join department
where eno=7788;

--3.join~using

select eno, ename, dno, dname
from employee join department
using (dno)
where eno=7788;

--4.join~on

select eno, ename, e.dno, dname
from employee e join department d
on e.dno=d.dno
where eno=7788;

--문제2. 3개 테이블 조인하기
--사원의 이름, 소속된 부서번호, 부서명, 급여, 급여등급 조회

--1.equi join

select ename, e.dno, dname, salary, grade as "급여 등급"
from employee e, department d, salgrade
where e.dno=d.dno
and salary between losal and hisal;

--2.join~on

select ename, e.dno, dname, salary, grade as "급여 등급"
from employee e join department d
on e.dno=d.dno
join salgrade
on salary between losal and hisal;

--3. natural join+join on

select ename, dno, dname, salary, grade as "급여 등급"
from employee natural join department join salgrade
on salary between losal and hisal;

--문제3. 모든 사원의 이름과 소속매니저이름(=직속상관) 출력(king포함)

--1.outer join
select e.ename as "사원 이름", m.ename as "직속 상관"
from employee e left outer join employee m
on e.manager=m.eno;

--2.equi join
select e.ename as "사원 이름", m.ename as "직속 상관"
from employee e, employee m
where e.manager=m.eno(+);

--문제4. equi 조인을 사용하여 scott 사원의 부서번호와 부서이름을 출력하시오.

select ename as "사원명", e.dno as "부서 번호", dname as "부서 이름" --사원명 생략가능
from employee e, department d
where e.dno=d.dno
and ename='SCOTT';

--문제5. (INNER)JOIN과 ON연산자를 사용하여 사원이름과 함께 그 사원이 소속된 부서이름과 지역명을 출력하시오.(=join on 사용)

select ename as "사원명", dname as "부서 이름", loc as "지역명"
from employee e join department d
on e.dno=d.dno;

--문제6. (INNER)JOIN과 USING 연산자를 사용하여 10번 부서에 속하는 모든 담당업무의 고유 목록(한번씩만 표시)을 부서의 지역명을 포함하여 출력하시오.(=join using 사용)

select distinct dno as "부서 번호", job as "담당 업무", loc as "지역명"
from employee join department
using (dno)
where dno=10;

--문제7. natural join을 사용하여 커미션을 받는 모든 사원의 이름, 부서이름, 지역명을 출력하시오.

select ename as "사원 이름", dname as "부서 이름", loc as "지역명"
from employee natural join department
where commission is not null;

--문제8. equi join과 wildCard를 사용하여 이름에 A가 포함된 모든 사원의 이름과 부서이름을 출력하시오.

select ename as "사원 이름", dname as "부서 이름"
from employee e, department d
where e.dno=d.dno
and ename like '%A%';

--문제9. natural join을 사용하여 NEWYORK에 근무하는 모든 사원의 이름,업무,부서번호,부서이름을 출력하시오.

select ename as "사원 이름", job as "담당 업무", dno as "부서 번호", dname as "부서 이름"
from employee natural join department
where loc='NEW YORK';

--문제10. self join을 사용하여 사원의 이름 및 사원번호를 관리자 이름 및 관리자 번호와 함께 출력하시오.

select e.ename as "사원 이름", e.eno as "사원 번호", m.ename as "관리자 이름", m.eno as "관리자 사원번호"
from employee e, employee m
where e.manager=m.eno;

--문제11. outer join or self join을 사용하여 관리자가 없는 사원을 포함하여 사원번호를 기준으로 내림자순 정렬하여 출력하시오.
--10번 문제에 관리자가 없는 사원을 추가하여 출력.

--방법1.outer join사용
select e.ename as "사원 이름", e.eno as "사원 번호", m.ename as "관리자 이름", m.eno as "관리자 사원번호"
from employee e left outer join employee m
on e.manager=m.eno
order by 2 desc;

--방법2.equi join 사용
select e.ename as "사원 이름", e.eno as "사원 번호", m.ename as "관리자 이름", m.eno as "관리자 사원번호"
from employee e, employee m
where e.manager=m.eno(+)
order by 2 desc;

--문제12. self join을 사용하여 지정한 사원의 이름(SCOTT), 부서번호, 지정한 사원과 동일한 부서에 근무하는 사원을 출력하시오.
--단, 각 열의 별칭은 이름, 부서번호, 동료로 하시오.

select e.ename as "사원 이름", e.dno as "부서 번호", d.ename as "동료"
from employee e, employee d
where e.dno=d.dno
and (e.ename='SCOTT' and not d.ename='SCOTT');--or and (e.ename='SCOTT' and d.ename!='SCOTT'); 

--문제13. self join을 사용하여 'WARD'사원보다 늦게 입사한 사원의 이름과 입사일을 입사일기준으로 오름차순 정렬로 출력하시오.

--방법1.
select h.ename as "사원 이름", h.hiredate as "입사일"
from employee e, employee h
where e.hiredate<h.hiredate
and e.ename='WARD'
order by 2;

--방법2.
select h.ename as "사원 이름", h.hiredate as "입사일"
from employee h, (select hiredate
				  from employee
				  where ename='WARD') e
where e.hiredate<h.hiredate
order by 2;

--방법3.위 방법과 같으나 위치만바뀜
select h.ename as "사원 이름", h.hiredate as "입사일"
from (select hiredate
	  from employee
	  where ename='WARD') e, employee h
where e.hiredate<h.hiredate
order by 2;

--문제14.self join을 사용하여 관리자보다 먼저 입사한 모든 사원의 이름 및 입사일을 관리자 이름 및 입사일과 함께 출력하시오.

select e.ename as "사원 이름", e.hiredate as "사원 입사일", m.ename as "관리자 이름", m.hiredate as "관리자 입사일"
from employee e, employee m
where e.manager=m.eno
and e.hiredate < m.hiredate;

/************************************************************************************************************************************/