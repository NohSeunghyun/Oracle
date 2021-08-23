--7장--<서브쿼리>

--'SCOTT'보다 급여를 많이 받는 사원을 찾기

--일반적인 방법으로 해결하기(해결하기 쉬운 순서 : 일반적인 방법으로 해결한것->서브쿼리 해결법에 넣기.)
--1)SCOTT의 급여를 알아야함.
select ename, salary
from employee
where ename = 'SCOTT';

--2)해당 급여 보다 많은 사람을 검색
select ename, salary
from employee
where salary > 985;

--메인쿼리-서브쿼리 로 문제해결하기 ★★문제에 쿼리사용해야할지 서브쿼리사용해야할지 헷갈릴수 있으므로 문제해석을 잘해야함.
select ename, salary
from employee
where salary > (select salary
				from employee
				where ename='SCOTT');
				--서브쿼리에서 실행한 결과(985)가 메인쿼리에 전달되어 최종 결과를 출력

--단일 행 서브쿼리 : 내부 쿼리의 결과가 행'1개'(=위 실행문같은것)
--				단일행 비교연산자 (>,=,>=,<=), IN연산자(비교연산자 "=" 일때만 사용가능.)
--				예) salary > 985 (행이1개.사용가능), salary IN(3000)(= salary=3000)
--				예) 100 > 1000, 2000 (행이2개.사용못함)

--다중 행 서브쿼리 : 내부 쿼리문의 결과가 행'여러개'
--				다중행 비교연산자 (In, Any, Some, All, Exists)

--1.단일 행 서브쿼리 활용하기

--문제1).'SCOTT'과 동일한 부서에서 근무하는 사원이름, 부서번호 출력

--일반적인 방법으로 해결하기
--1).'SOCTT'부서번호 알기
select dno
from employee
where ename = 'SCOTT';--결과 20번부서

--2).해당부서와 같은 사원이름, 부서번호 조회
select ename, dno
from employee
where dno=20;

--단일 행 서브쿼리 활용
select ename, dno
from employee
where dno = (select dno
			 from employee
			 where ename='SCOTT');

--단일 행 서브쿼리 활용 - IN연산자 활용
select ename, dno
from employee
where dno in (select dno
		      from employee
			  where ename='SCOTT');--서브쿼리 결과 1개

--위 결과에는 'SCOTT'도 함께 출력. 'SCOTT'을 제외해서 출력
select ename, dno
from employee
where dno = (select dno
		      from employee
			  where ename='SCOTT')
and ename !='SCOTT';--조건추가

--풀이
select ename, dno
from employee
where dno = 20--서브쿼리 결과값
and ename !='SCOTT';--이렇게 풀이가 된다.

--문제2).회사전체에서 최소 급여를 받는 사원의 이름, 담당직업, 급여 조회

--일반적인 방법으로 해결하기(순서)
--1).최소 급여 구하기
select min(salary)
from employee;

--2).구한 최소 급여를 받는 사원의 이름, 담당직업, 급여 조회
select ename, job, salary
from employee
where salary = 950;

--단일 행 서브쿼리 활용 
select ename, job, salary
from employee
where salary = (select min(salary)
			    from employee);

--단일 행 서브쿼리 활용 - IN연산자 활용
select ename, job, salary
from employee
where salary in (select min(salary)
			 	 from employee);--(=IN(800)).서브쿼리 결과 1개
			  
--2.다중 행 서브쿼리
--1).IN연산자 : 메인쿼리의 비교조건에서 서브쿼리의 출력결과와 '하나라도 일치하면'
--			    메인쿼리의 where절이 참
--★단일 행 또는 다중 행 서브쿼리에 둘다 사용가능함.그래서 자주 사용함.

--문제1).부서별 최소급여를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회 (in연산자 사용)

--순서
--1).부서별 최소급여를 구하기
select dno, min(salary)--어느부서에 해당하는지 알수는 없으나 최소급여만 알고자 하는것이기 때문에 dno를 뻬도됨. 그룹 3:3 매칭되어 사용가능.
from employee
--where 검색조건 필요없으니 X
group by dno;--부서번호가 없으면 출력값이 어떤부서에 해당하는지 알수없기 때문에 select에 dno추가.
--having 그룹에 대한 조건 필요없으니 X
--order by 정렬 필요없으니 X

select dno, ename, eno, salary
from employee
order by 1;--중복이 있어서 부서번호  및 급여확인하기위해 쓴 실행문

--------------------------------------------------------------------------------------------------------------------------------------

-- 이 문제와 쿼리에 관한 내용은 natural join 해결문 아래 기술
-- 중복문제를 해결하기위해 쿼리문 수정을 많이해서 보기가힘듬.
-- 해결법은 아래. 이 문제에관한 자세한 내용은 natural join 해결문 아래 기술
--2).구한 부서별 최소급여를 받는 사원번호, 사원이름, 급여 조회--10번부서의 최소급여가 1100, 20번 부서의 최소급여는 985이나 1100을 받는 사원이있고,
--												 30번 부서의 최소급여가 950이나 1100을 받는 사원이 있으면 (중복되는경우)
--												  사원이름, 사원번호는 출력하지 못한다.

select dno, min(salary) as 최소급여--select dno, eno, ename, min(salary)안됨//eno,ename 출력못함
from(select dno, eno, ename, salary
	 from employee
	 where salary in (select min(salary)--★IN() 안에 서브쿼리에는 select dno, min(salary)안됨.무조건 dno빼야함.
			 	      from employee
			 		  group by dno));
group by dno;--group by dno, eno, ename, salary;매칭시키기 위해 했으나 결과가 다시 중복된걸로 나옴.
--			 In(950, 985, 1100);서브 쿼리의 실행 결과가 여러 개 이므로 '='과 같은 비교연산자 사용불가능. 
--			 이 실행문은 잘못된 실행문. 전체테이블에서 부서별 최소급여에 해당하는 급여를 받는 사원들 전부가 출력됨.
--			 부서별 최소급여를 출력못함.

--------------------------------------------------------------------------------------------------------------------------------------

--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

--해결법
select e.dno, e.eno, e.ename, e.salary -- e.dno나 s.dno 둘중 아무거나 적어도 값은 동일하나 생략은 불가능. 두테이블에 같은컬럼이 있기때문
			 					       -- eno, ename, salary는 e사원테이블에만 존재하기 때문에 생략가능.
from employee e, ( -- 단순히 사원테이블을 e라고 별칭을 붙임.
					select dno, min(salary) as min_sal -- 최소급여를 별칭'min_sal'로붙임. 별칭 안붙일 시 밑의 검색조건에서 사용이 안됨. 왜지...? 어쩌다가 이것저것 하다 이걸로하니 실행됨;;
					from employee
					group by dno) s -- 각 부서별로 부서번호와 최소급여의 '결과값'을 s로 별칭붙임. 
							        -- 네이버에 찾아보니 from절에도 서브쿼리가 들어갈수 있는걸 참조. 
							        -- from절에 서브쿼리로 값을넣고 s로 별칭을 붙인 후 join함
where e.dno = s.dno -- equi join으로 서브쿼리의 값과 조인 조인조건은 부서번호. 
		  			-- 여기까지만 적고 실행할 시 조회문에 s의 컬럼이 없기때문에 e테이블의 모든사원의 출력하고자하는 정보값만나온다.
and e.salary = s.min_sal -- 검색조건. e사원테이블에서 모든사원의 급여 중 s가 참조하는 최소급여(각 부서별 최소급여)와 같은것만 출력하고자하는 정보와 함께 출력함. 
order by 1;

--선생님 해결법 1). 서브쿼리와 메인쿼리를 연결하는 검색조건을 컬럼한개(dno) 더 추가.
--제일 간단하고 간결한거 같음.
select dno, eno, ename, salary
from employee
where (dno, salary) in (select dno, min(salary)
			 	 		from employee
			 	 		group by dno)
order by 1;

--선생님 해결법 2). 조인으로해결. 위 해결법 정리

--순서[1]. 부서별 최소급여 확인
select dno, min(salary)
from employee
group by dno;

--순서[2-1]. 조인하기 테이블에 서브쿼리를 넣어 equi 조인사용
select *
from employee e1, (select dno, min(salary)
				   from employee
				   group by dno)e2
where e1.dno=e2.dno;--조인조건
--결과를 보고 e1테이블의 셀러리와 e2의 셀러리값이 같은걸 출력하면 나온다는걸 확인함.

--순서[3]. 검색조건넣기, 출력하고자하는 정보만 넣기
select e1.dno, eno, ename, salary
from employee e1, (select dno, min(salary) as minsalary --꼭 별칭 붙여야함
				   from employee
				   group by dno)e2
where e1.dno=e2.dno
and e1.salary=e2.minsalary
order by 1;

--순서[2-2]. natural join 써보기 (테이블 별칭 필요없음. 중복 제거. 조인조건 필요없음.)
select dno, eno, ename, salary
from employee natural join (select dno, min(salary) as minsalary 
				   			from employee
		   				    group by dno)
where salary=minsalary
order by 1;

--------------------------------------------------------------------------------------------------------------------------------------

--부서별 최소급여가 아닌 최소급여값인(950,985,1100)인 사원이 전체테이블에서 다나오기때문에(=급여가 최소급여값과 같은사람 다나옴) 문제 답에 해결되지않음.
select dno, eno, ename, salary
from employee
where salary in (select min(salary)
			 	 from employee
			 	 group by dno);

--아래 쿼리는 사원번호, 사원이름을 함께 출력 못함.
select dno, eno, ename, min(salary)
from employee
where salary in (select min(salary)
			 	 from employee
			 	 group by dno)
group by dno
order by 1;

--사원번호,사원이름 제거하면 실행가능. 하지만 출력하고자하는 사원이름과 사원번호을 출력못함.
select dno, min(salary)
from employee
--where salary in (select min(salary)
--			 	   from employee
--			 	   group by dno)--지금 이 쿼리문에는 조회에 최소급여를 구하는게 있기때문에 검색조건이 필요가없음. 각 부서별 최소급여'만' 뽑는것이기때문에
group by dno
order by 1;

--두번째 쿼리를 실행가능하게. 하지만 중복결과도 함께 나오기때문에 위의 해결법들(141번째 줄~194번째 줄) 참조.
select dno, eno, ename, salary, min(salary)--그룹함수를 사용하려면 group by를 사용해야함.단, 전체에관한것을 조회하려면 생략가능.
from employee                                                                    --ex)select min(salary)
where salary in (select min(salary)                                              --   from employee;
			 	 from employee                                                   --전체대상이면 group by 사용안함
			 	 group by dno)--in (950, 985, 1100)으로 써도됨                                            --전체가 하나의 그룹이므로 사용안함.
group by dno, eno, ename, salary--group by 뒤에 반드시 출력할 컬럼들을 같이 나열.
order by 1;

--★★그룹함수만 group by 사용가능. (5장 그룹함수 참조)

--바로 위의 쿼리가 안되는 이유.
select dno, min(salary)
from employee--; 조회(=select)에 dno를 제거하고 여기까지만 실행하면 어느부서의 최소급여인지 알길이 없기때문에 무의미한 결과가 된다.
group by dno;--, eno;를 넣을시 (조회에 dno,eno넣고) eno가 같은사람이 없기때문(eno의 값이 전부 다름)에 그룹으로 만들지 않은것과 값이 같아짐.
			 --, eno, salary;를 넣을시 eno때문에 오류가안남.매칭이됨(=eno를넣으면 그룹을 만들지않은것과 값이 같기때문에)

--------------------------------------------------------------------------------------------------------------------------------------

--2).any 연산자 : 서브쿼리가 반환하는 각각의 값과 비교
--where 컬럼명 = any (서브쿼리의 결과1, 결과2, ...) => 결과들 중 아무거나와 같다. // any보다 in을 쓰는게 나음.
-- = where 컬럼명 IN (서브쿼리의 결과1, 결과2, ...) 

--where 컬럼명 < any (서브쿼리의 결과1, 결과2, ...) => 결과들 중 최대값보다 작다.
--where 컬럼명 > any (서브쿼리의 결과1, 결과2, ...) => 결과들 중 최소값보다 크다.

--문제1).부서별 최소급여를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회 (any연산자 사용)
select dno, eno, ename, salary
from employee
where (dno, salary) = any (select dno, min(salary)
						   from employee
						   group by dno)
order by 1;
						   
--정리 : where (dno, salary) = any (10 950, 20 985, 30 1100)(=10번부서에서 급여는 950 20번부서에서 급여는 985 30번부서에서 급여는 1100)
--		where (dno, salary)    in (10 950, 20 985, 30 1100)(=10번부서에서 급여는 950 20번부서에서 급여는 985 30번부서에서 급여는 1100)
--서브쿼리의 결과 중 아무거나와 같은것.

--정리 : where salary <> any (950, 985, 1100)
--	    where salary != any (950, 985, 1100)
--	    where salary not in (950, 985, 1100)
--서브쿼리의 결과 중 어느것도 아니다.

--정리 : where salary < any (950, 985, 1100) 서브쿼리의 결과 중 최대값보다 작다.
--	    where salary > any (950, 985, 1100) 서브쿼리의 결과 중 최소값보다 크다.
--예1)
select eno, ename, salary
from employee
where salary < any (select min(salary)
					from employee
					group by dno)
order by 1;
--검색순서
--           < any(950, 985, 1100)
--           < 950
--           < 985
--           < 1100
--결국                < 1100 (최대값)의 범위가 나머지범위 다 포함함.

--예2)
select eno, ename, salary
from employee
where salary > any (select min(salary)
					from employee
					group by dno)
order by 1;
--검색순서
--           > any(950, 985, 1100)
--           > 950
--           > 985
--           > 1100
--결국                > 950 (최소값)의 범위가 나머지범위 다 포함함.

--문제2).직업이 세일즈맨(SALESMAN)이 아니면서 급여가 임의의 세일즈맨보다 낮은 사원의 정보(이름, 직업, 급여) 출력 (*임의의=각각)
--이해하기쉬운(=풀기쉬운)순서
--1).직업이 세일즈맨인 급여구하기
select distinct salary--만약 중복값이 있다면 distinct를 사용해 중복제거.
from employee
where job='SALESMAN';
--2).문제해결(결합)
select ename, job, salary
from employee
where job != 'SALESMAN' and salary < any (select distinct salary
										  from employee
										  where job='SALESMAN')--이 결과의 최대값보다 작은 것을 검색하기때문에 where salary < 1150과 같은 결과가됨.
order by 3;													   --salary < any( , , ) : 서브쿼리 결과중 최대값보다 작다.

--위 결과를 검증
select ename, job, salary
from employee
where job != 'SALESMAN' and salary < any (select max(salary)
										  from employee
										  where job='SALESMAN')--세일즈맨중 최대급여를 구하여 비교하기때문에 위의결과와 같은지 확인.
order by 3;

--where job != 'SALESMAN' 에서 !=대신 쓸수있는것들.
--      job <> 'SALESMAN'
--      job ^= 'SALESMAN'
--      job not like 'SALESMAN'

--문제 다시풀기).직업이 세일즈맨(SALESMAN)이 아니면서 급여가 임의의 세일즈맨보다 낮은 사원의 정보(이름, 직업, 급여) 출력 (*임의의=모든)
select ename, job, salary
from employee
where job !='SALESMAN' and salary < any (select salary
										 from employee
										 where job='SALESMAN')
order by 3;

--------------------------------------------------------------------------------------------------------------------------------------

--3).all 연산자 : 서브쿼리에서 반환되는 모든 값과 비교
--정리 : A조건 and B조건 - 여러조건을 동시에 만족
--where salary > all(서브쿼리결과1, 결과2, ...) : 서브쿼리결과 중 최대값보다 크다. 
--where salary < all(서브쿼리결과1, 결과2, ...) : 서브쿼리결과 중 최소값보다 작다. 

select job, salary
from employee
where job='SALESMAN' and (salary > 1100 or salary > 1110 or salary > 1120);--any 연산자
--or은 '크거나' 로 해석
--결국 조건중 최소값보다 큰걸로 해석

select job, salary
from employee
where job='SALESMAN' and (salary > 1100 and salary > 1110 and salary > 1120);--all 연산자
--and는 '크고' 로 해석
--결국 조건중 최대값보다 큰걸 검색.

--문제.직업이 SALESMAN이 아니면서
--급여가 모든 SALESMAN보다 낮은 사원의 정보(이름, 직업, 급여)출력 (모든=모두 동시에 만족)
--[1].직업이 SALESMAN인 급여 구하기
select distinct salary--결과4개(1100, 1115, 1120, 1150)
from employee
where job='SALESMAN';
--[2].
select ename, job, salary
from employee
where job !='SALESMAN' and salary < all (select salary
										 from employee
										 where job='SALESMAN');
						 --salary < all (결과1,결과2,..) : 서브쿼리 결과 중 '최소값'보다 작다.

--위 결과를 검증
--[1]
select min(salary)
from employee
where job='SALESMAN';--1100

--[2]
select ename, job, salary
from employee
where job !='SALESMAN' and salary < all (select min(salary)
										 from employee
										 where job='SALESMAN');

--------------------------------------------------------------------------------------------------------------------------------------

--3).exists 연산자 : exists=존재하다.
select
from
where exists(서브쿼리);
--서브쿼리에서 구해진 데이터가 1개라도 존재하면 Ture->메인쿼리 실행
--						1개도 존재하지 않으면 False->메인쿼리 실행안함

select
from
where not exists(서브쿼리);
--서브쿼리에서 구해진 데이터가 1개라도 존재하면 False->메인쿼리 실행안함
--						1개도 존재하지 않으면 Ture->메인쿼리 실행

--문제1. 사원테이블에서 직업이 'PRESIDENT'가 있으면 모든 사원이름을 출력, 없으면 출력안함.
--문제의 뜻 : 조건을 만족하는 사원이 있으면 메인쿼리를 실행하여 결과출력,없으면 메인쿼리 실행안함.
--[1]사원테이블에서 직업이 'PRESIDENT'인 사원번호 조회
select eno
from employee
where job='PRESIDENT';--7839
--[2]
select ename
from employee
where exists (select eno
			  from employee
			  where job='PRESIDENT');
--------------------------------------------------------------------------------------------------------------------------------------
--위 문제+직업이 SALESMAN인 사원만 출력
--(and로 연결) : 두 조건이 모두 참이면 참
select job, ename
from employee
where job='SALESMAN' and exists (select eno
			  					 from employee
			  					 where job='PRESIDENT');
			  					 
--위 문제+직업이 SALESMAN인 사원만 출력(and로 연결하고 잘못된 실행문)  
select job, ename
from employee
where job='SALESMAN' and not exists (select eno
			  						 from employee
			  						 where job='PRESIDENT');
			  					 
--위 문제+직업이 SALESMAN인 사원만 출력
--(or로 연결) : 두 조건 중 하나만 참이면 참
select job, ename
from employee
where job='SALESMAN' or not exists (select eno
			  						from employee
			  						where job='PRESIDENT');
--------------------------------------------------------------------------------------------------------------------------------------
--위 문제를 테스트하기위해 직업이 'PRESIDENT'를 삭제
delete
from employee
where job='PRESIDENT';

--문제2. 사원테이블에서 직업이 'PRESIDENT'가 없으면 모든 사원이름을 출력, 없으면 출력안함.
--문제의 뜻 : 조건을 만족하는 사원이 없으면 메인쿼리를 실행하여 결과출력,있으면 메인쿼리 실행안함.
--[1]사원테이블에서 직업이 'PRESIDENT'인 사원번호 조회
select eno
from employee
where job='PRESIDENT';--7839
--[2]
select ename
from employee
where not exists (select eno
				  from employee
				  where job='PRESIDENT');
				  
--위 문제 테스트를 하고난 후 다시 원상복구하기위해 'PRESIDENT'를 생성
INSERT INTO EMPLOYEE VALUES(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),1800,700,10);
			  
/************************************************************************************************************************************/