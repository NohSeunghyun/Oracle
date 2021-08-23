--문제1. 사원번호가 7788인 사원과 담당업무가 같은 사원을 표시(사원이름과 담당업무 출력)

--[1]사원번호가 7788인 사원의 담당업무확인
select job
from employee
where eno=7788;--'ANALIST'

--[2]
select ename, job
from employee
where job=(select job -- '=' 대신 'in','= any' 사용해도됨 (= any : 서브쿼리결과 1개이상 가능)
		   from employee
		   where eno=7788);

--문제2. 사원번호가 7499인 사원보다 급여가 많은 사원을 표시(사원이름과 담당업무 출력)
		   
--[1]사원번호가 7499인 사원의 급여확인
select salary
from employee
where eno=7499;--1100

--[2]
select ename, job
from employee
where salary > (select salary
				from employee
				where eno=7499);
				
--문제3. 최소급여를 받는 사원의 이름, 담당업무 및 급여표시(그룹함수 사용)

--[1]사원테이블에서 모든사원중 최소급여 확인
select min(salary)
from employee;--950

--[2]
select ename, job, salary
from employee
where salary = (select min(salary) -- '=' 대신 'in','= any' 사용해도됨 (= any : 서브쿼리결과 1개이상 가능)
				from employee);

--문제4. 직급별 평균 급여가 가장 적은 담당업무를 찾아 직급(job)과 평균 급여 표시
--단, 평균의 최소급여는 소수1째자리까지 표시
--[1]직급별 평균급여 중 가장적은 평균급여를 구하기
--1)
select avg(salary), round(avg(salary),1)--소수둘째자리에서 반올림하여 첫째자리까지 표시
from employee;

--2).잘못된 다음순서
select min(avg(salary))
from employee--오류. avg(salary)의 결과는 1개인데 min함수는 필요없으므로.
				--avg(salary)의 결과1개에 대한 최대값이나 최소값을 구하는것 자체가 잘못됨.
--2).
select job, round(avg(salary),1)--5:5결과 나옴
from employee
group by job;

--3).잘못된 다음순서 job:min(avg(salary))=5:1 매칭안됨.->오류
select job, min(round(avg(salary),1))--여러 avg(salary)의 최소값은 단 1개이므로.
from employee
group by job;

--3).
--★★그룹함수는 최대2개까지만 중첩 허용.
--그룹함수:min, avg, sum, max
--round, trunc 함수는 그룹함수가 아님.
select min(round(avg(salary),1))--여러 avg(salary)의 최소값은 단 1개이므로.
from employee
group by job;

--[2]서브쿼리로 결합
select job, round(avg(salary),1)
from employee
group by job
having avg(salary)=(select min(avg(salary)) --주의. 비교대상(=)이 1개일때 서브쿼리의 결과컬럼도 1개여야함.
					from employee
					group by job);

--다른학생의 방법
--[1]
select job, round(avg(salary), 1)
from employee
group by job
order by avg(salary);--정렬 : 가장 적은 평균이 1번째 줄에
-- = order by 2 asc;

--[2]
select *
from(select job, round(avg(salary), 1)
	 from employee
     group by job
     order by avg(salary))
where rownum =1;--맨 윗줄만 뽑아 출력.

--문제5. 각 부서의 최소 급여를 받는 사원의 이름, 급여, 부서번호 표시
select ename, salary, dno
from employee
where (dno, salary) in (select dno, min(salary)
				 		from employee
				 		group by dno);
				 		
--문제6-1. 담당업무가 분석가(ANALYST)인 사원중 급여가 제일 큰 사원보다 급여가 적으면서 업무가 분석가가 아닌 사원들을 표시 (사원번호, 이름, 담당업무, 급여)
select eno, ename, job, salary
from employee
where job!='ANALYST' and salary < all (select salary
									   from employee
									   where job='ANALYST');
-- !=대신 ^=, <>, not like 사용가능

--문제 6-2. 담당업무가 분석가(ANALYST)인 사원중 급여가 제일 큰 사원보다 급여가 적으면서 업무가 분석가가 아닌 사원들을 표시 (사원번호, 이름, 담당업무, 급여)
select eno, ename, job, salary
from employee
where job!='ANALYST' and salary < any (select salary
									   from employee
									   where job='ANALYST');
-- !=대신 ^=, <>, not like 사용가능

--★★문제7. 부하직원이 없는 사람 이름 표시 -자기 사원번호가 매니저컬럼에 들어가있지 않는사람.

--방법1.서브쿼리
--방법1-1.서브쿼리 활용(in연산자)--any연산자는 각각의 결과에 비교하기때문에 모든사원이 나옴;;
							--서브쿼리 결과중 어느것도 아니다 라고 배운 3가지
							--not in, <> any, != any인데 any연산자 2개는 not in과다른 값이 나온다;
--[1]상관사원번호 출력
select distinct nvl(manager,0) --distinct안써도 서브쿼리결합시 중복된것 안나옴
from employee;

--상관사원번호(manager컬럼)에 자신의 사원번호(eno)가 없으면 부하직원이 없는 사원이 됨.
--[2]서브쿼리로 결합
select ename
from employee
where eno not in (select nvl(manager,0) --null값이 있으면 값이 안나오기때문에 0으로 바꿈.
				  from employee);

--방법1-2.서브쿼리 활용(in연산자) 위 방법과 같으나 nvl함수를 안쓰는것.
--[1]상관사원번호 출력 (null값 제외)
select distinct manager
from employee
where manager is not null;

--상관사원번호(manager컬럼)에 자신의 사원번호(eno)가 없으면 부하직원이 없는 사원이 됨.
--[2]서브쿼리로 결합
select ename
from employee
where eno not in (select manager
				  from employee
				  where manager is not null);
				  
--방법1-3.서브쿼리 활용(any연산자) - 잘못된 방법 : 합집합이기때문
select ename
from employee
where eno != any (select manager -- != any 또는 <> any
				  from employee
				  where manager is not null);
--eno != 7839 아닌사원--13명
--eno != 7782 아닌사원--13명 ....(조건값만족까지)
--중복 제외하고 모두 나열하면 14명이 결과로 나옴. 그래서 모든값이나온다.

--선생님풀이법
--[1]
select distinct manager
from employee
where manager is not null;

--[2]
select ename
from employee
where eno not in (select distinct manager
			  	  from employee
			  	  where manager is not null);

--위 결과들을 검증
select ename
from employee
where eno not in (7839, 7782, 7698, 7902, 7566, 7788); --null 이 있으면 값이 안나옴.

--★★문제8. 부하직원이 있는 사람 이름 표시 -자기 사원번호가 매니저컬럼에 들어가 있는 사람.

--방법1. self 조인
--방법1-1.equi join 활용
select distinct m.ename
from employee e, employee m
where e.manager = m.eno;

--방법1-2.join on 활용
select distinct m.ename
from employee e join employee m
on e.manager = m.eno;

--방법2. 서브쿼리
--방법2-1.서브쿼리 활용(in연산자)
--[1]상관사원번호 출력
select distinct manager --distinct안써도 서브쿼리결합시 중복된것 안나옴
from employee;

--상관사원번호(manager컬럼)에 자신의 사원번호(eno)가 있으면 부하직원이 있는 사원이 됨.
--[2]서브쿼리로 결합
select ename
from employee
where eno in (select manager
	     	  from employee);

--방법2-2.서브쿼리 활용(any연산자) : 각각의 결과값이 eno와 같은것을 찾는다(=합집합)
--합집합 : 각각 만족하는 조건의 결과를 다 합침
--[1]상관사원번호 출력
select distinct manager
from employee;

--상관사원번호(manager컬럼)에 자신의 사원번호(eno)가 있으면 부하직원이 있는 사원이 됨.
--[2]서브쿼리로 결합
select ename
from employee
where eno = any (select manager
				 from employee);

--방법2-3.서브쿼리 활용(all연산자) - 잘못된 방법 : 모든 결과값이 eno와 같은것을 찾는다 (=교집합) 
--서브쿼리 결과값 모두를 비교하는 all연산자를 쓰면( eno = all (서브쿼리)) 값이 안나온다.
--교집합 : 모든 조건을 동시에 만족하는 값
select ename
from employee
where eno = all (select manager
				 from employee);
				 
--위 결과의 이유
select ename
from employee
where eno = all (7839, 7782, 7698, 7902, 7566, 7788, null);--결과값을 동시에 만족하는 값을 찾기때문에
--														eno=7839, 7782, 7698, 7902, 7566, 7788, null인 값은 없다.

--선생님풀이법
--[1]
select distinct manager
from employee
where manager is not null;

--[2]
select ename
from employee
where eno in (select distinct manager
			  from employee
			  where manager is not null);
			 
--위 결과들을 검증
select ename
from employee
where eno in (7839, 7782, 7698, 7902, 7566, 7788, null); --null이 있어도 값이 나옴. 7번문제와 차이점?? 

--문제9.BLAKE와 동일한 부서에 속한 사원이름과 입사일을 표시(단, BLAKE는 제외)
--[1]BLACK의 부서 구하기
select dno
from employee
where ename='BLAKE';--30번부서

--[2]같은 부서의 사원이름과 입사일구하기 BLAKE는제외
select dno, ename, hiredate--문제에 의거하면 dno빼야됨 확인차적음
from employee
where dno in (select dno
			  from employee
			  where ename='BLAKE')
and ename != 'BLAKE';

--문제10.급여가 평균급여보다 많은 사원들의 사원번호와 이름 표시(결과는 급여에 대해 오름차순 정렬)
--[1]평균급여 구하기
select round(avg(salary))--보기좋게 하려고 round함수사용 소수점날림
from employee;

--[2]평균급여보다 많은 사원 번호와 이름 구하기
select eno, ename, salary--문제에 의거하면 salary빼야됨 확인차적음
from employee
where salary > (select round(avg(salary))
				from employee)
order by salary;
				
--문제11.이름에 K가 포함된 사원과 같은 부서에서 일하는 사원의 사원번호와 이름 표시
--[1]이름에 K가 포함된 사원의 부서번호
select dno
from employee
where ename like '%K%';

--[2]같은부서에서 일하는 사원의 사원번호와 이름
select dno, eno, ename--문제에 의거하면 dno빼야됨 확인차적음
from employee
where dno in (select distinct dno
			  from employee
			  where ename like '%K%');
			  
--문제12.부서위치가 DALLAS인 사원 이름과 부서번호 및 담당업무 표시
--equi join
select ename, e.dno, job --dno는 사원,부서테이블 둘다 존재하기에 앞에 별칭을 붙여 어디테이블에서 갖다쓸지 적어야함
from employee e, department d
where d.dno=e.dno --조인조건
and loc='DALLAS'; --검색조건

--natural join --더 쓰기 편함. 다른조인 적기 힘들어 생략
select ename, dno, job
from employee natural join department
where loc='DALLAS'; --검색조건. natural join은 조인조건x 자연스럽게 조인

--서브쿼리
--[1]부서위치가 DALLAS인 부서번호구하기
select dno
from department
where loc='DALLAS';

--[2]서브쿼리 결합
select ename, dno, job
from employee
where dno in (select dno
			  from department
			  where loc='DALLAS');

--추가문제12. 부서위치가 DALLAS인 사원이름, 부서번호, 담당업무, 부서위치 표시
--natural join
select ename, dno, job, loc
from employee natural join department
where loc='DALLAS';

--서브쿼리
--[1]부서위치가 DALLAS인 부서번호 구하기
select dno
from department
where loc='DALLAS';

--[2]서브쿼리+조인
select ename, dno, job, loc
from employee natural join department
where dno in (select dno
			  	from department
			  	where loc='DALLAS');
			  	
--문제13.KING에게 보고하는 사원이름과 급여표시
--[1]king의 사원번호 출력
select eno
from employee
where ename='KING';

--[2]서브쿼리 결합
select ename, salary
from employee
where manager = (select eno
				 from employee
				 where ename='KING');
				 
--문제14.RESEARCH 부서의 사원에 대한 부서번호, 사원이름, 담당업무 표시
--equi join
select e.dno, ename, job
from employee e, department d
where e.dno=d.dno --조인조건
and dname='RESEARCH'; --검색조건

--natural join --더 쓰기 편함. 다른조인 적기 힘들어 생략
select dno, ename, job
from employee natural join department
where dname='RESEARCH'; --검색조건. natural join은 조인조건x 자연스럽게 조인

--서브쿼리
--[1]RESEARCH 부서번호 구하기
select dno
from department
where dname='RESEARCH';

--[2]서브쿼리 결합
select dno, ename, job
from employee
where dno=(select dno
		   from department
		   where dname='RESEARCH');	
		   
--문제15.평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원과 같은 부서에서 근무하는 사원이름, 사원번호, 급여 표시
--'평균급여보다 많은 급여를 받고 이름에 M이 포함된 사원' 과 같은 부서에서 근무하는 사원을 구해야하는가? --내가푼방법 --다른사람 안나옴. 나만 데이터 변경해서
--'이름에 M이 포함된 사원과 같은부서에서 근무하는 사원 중'에서 평균급여보다 많은 급여를 받는사람을 구해야하는가? --선생님풀이
--[1]평균급여 구하기
select round(avg(salary),0)
from employee;--소수점 제거

--나
--[2]평균급여보다 많고 이름에 M이 포함된 사원의 부서번호 구하기
select dno
from employee 
where ename like '%M%'
and salary > (select round(avg(salary),0)
			  from employee);
--이름에 M이 포함되고 급여가 평균급여가 많은 사람은 10,20번부서에 있다.

--[3]같은 부서에서 근무하는 사원 이름,번호,급여 표시
select dno, ename, eno, salary
from employee
where dno in (select dno
			  from employee 
			  where ename like '%M%'
			  and salary > (select round(avg(salary),0)
							from employee))
and ename not like '%M%'--M이 포함된 사원은 제거
order by 1;
--이 결과의 문제는 '평균급여보다 많은 급여를 받고 이름이M이 포함된 사원' 과 같은 부서에서 근무하는 사원이름, 번호, 급여 표시가 정확함
--기존 데이터를 제맘대로 바꾼것 때문에 다른분들은 이 실행문이 안나옴 평균급여보다 높고 이름에 M이 포함된 사원이 없기때문

--선생님
--[2]이름에 M이 포함된 사원의 부서번호 구하기
select dno
from employee 
where ename like '%M%';

--근데 이방법을 사용하면 30번부서도 나온다.
--[3]같은 부서에서 근무하는 사원 이름,번호,급여 표시
select dno, ename, eno, salary
from employee
where salary > (select round(avg(salary),0)
				from employee)
				and dno in (select dno
							from employee 
							where ename like '%M%')
and ename not like '%M%';--M이 포함된 사원은 제거
--이 결과의 문제는 이름에 M이 포함된 사원과 같은 부서에서 근무하는 사원 중 평균급여보다 많은 급여를 받는 사원이름, 사원번호, 급여 표시이 더 정확함

--문제16.평균급여가 가장 적은 업무와 그 평균급여 표시
--[1]업무별 가장적은 평균급여
select min(avg(salary))
from employee
group by job;--여기서 select에 job을 추가하면 5:1로 매칭안됨

--[2]가장 적은 업무와 평균급여
select job, round(avg(salary),0)
from employee
group by job
having avg(salary)=(select min(avg(salary))
					from employee
					group by job);

--문제17.담당업무가 MANAGER인 사원이 소속된 부서와 동일한 부서의 사원이름 표시
--문제가 이상한거같음. 업무가 manager인 사원은 모든부서에 있음
--[1]업무가 MANAGER인 사원이 소속된 부서
select dno
from employee
where job='MANAGER';

--[2]서브쿼리 결합
select ename
from employee 
where dno in (select dno
			  from employee
			  where job='MANAGER');

/*************************************************************************************************************************************/