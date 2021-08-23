/*
 * 이름이 SCOTT인 사원의 모든정보출력
 */

select * --테이블속 칼럼명 *은 모든정보
from employee --테이블명
where ename='SCOTT'; --찾고자하는 정확한 경로

--정보 만들때 '문자'값 대소문자 구분하기때문에 써치도 대소문자구분.

select *
from employee
where ename='scott';--데이터명 입력할때 대문자로해서 소문자로하면 에러(검색안됨)남

/*
 * 1981년 1월 1일 이전에 입사한 사원만 출력 
 */

select *
from employee
where hiredate<='1981/01/01';--'날짜'<=기준점:기준점보다 작거나같은 정보 >=기준점:기준점보다 크거나같은 정보

/*
 * 논리연산자
 * 10번부서소속인 사원중 직급이 manager인 사원검색
 */

select *
from employee
where dno=10 and job='MANAGER';--원하는값 둘다 만족하는 결과출력

select *
from employee
where dno=10 or job='MANAGER';--원하는값 둘중 하나라도 만족하는 결과출력

/*
 * 10번부서에 소속된 사원만 제외하기
 * not:참<->거짓
 * 같지않다:<> , != , ^= *같다:=
 */

select *
from employee
where not dno=10;

select *
from employee
where dno<>10;-- !=,^=사용가능

/*
 * 급여가 1000-1300 사이인 사원출력
 * between:범위 사의값을 모두 검색하는 연산자
 */

select *
from employee
where salary>=1000 and salary<=1300;--부호를 사용할경우 범위값은 and사용

select *
from employee
where salary between 1000 and 1300;

/*
 * 급여가 1000미만이거나 1300 초과인 사원검색
 * 미만:< 이하:<= 이상:>= 초과:>
 */

select *
from employee
where salary not between 1000 and 1300;

select *
from employee
where salary<1000 or salary>1300;--부호를 사용할경우 미만,초과값은 or사용

/*
 * 1982년에 입사한 사원정보 출력
 */

select *
from employee
where hiredate>='1982-01-01'and hiredate<='1982-12-31';

select *
from employee
where hiredate between '1982-01-01'and '1982-12-31';

select *
from employee
where hiredate between '1982/01/01'and '1982/12/31';

/*
 * IN 연산자
 * 커미션이 100이거나 150이거거나 200인 사원정보 검색
 * 컬럼명 in(수,수..)
 */

select *
from employee
where commission=100 or commission=150 or commission=200;

select *
from employee
where commission in (100,150,200);

/*
 * 커미션이 100,150,200이 아닌 사원정보 검색
 * 컬럼명 not in(수,수..)
 */

select *
from employee
where commission<>100 and commission!=150 and commission^=200;

select *
from employee
where commission not in (100,150,200);

/*
 * LIKE 연산자
 * 이름이 F로 시작하는 사원출력
 * %:문자가 없거나 하나이상의 문자가 어떤값이 와도 상관없다.
 */

select *
from employee
where ename like 'F%';

--이름에 M이 포함된 사원출력

select *
from employee
where ename like '%M%';

--이름이 S로 끝나는 사원출력

select *
from employee
where ename like '%S';

--이름의 두번째 글자가 A인 사원출력

select *
from employee
where ename like '_A%';-- _:하나의 문자가 어떤값이 와도 상관없다.

--이름의 세번째 글자가 A인 사원출력

select *
from employee
where ename like '__A%';

--이름의 A가 포함,포함되지 않은 사원 출력

select *
from employee
where ename like '%A%';--포함

select *
from employee
where ename not like '%A%';--포함되지 않은

/*
 * NULL 연산자
 * NULL은 비교연산자로 비교불가하므로 결과가 안나옴.
 */

select *
from employee
where commission=null;

select *
from employee
where commission is null;--커미션이 null인 사원

select *
from employee
where commission is not null;--커미션이 null이 아닌사원

--정렬해서보기 

select *
from employee
order by salary asc;--오름차순정렬

select *
from employee
order by salary desc;--내림차순 정렬

select *
from employee
order by salary asc, commission desc;--salary는 오름차순정렬, 만약 같을경우 commission은 내림차순정렬

select *
from employee
order by eno;--asc생략가능, desc생략불가능

select *
from employee
order by salary, eno desc;--salary 오름차순정렬(생략),같은경우 eno내림차순정렬

select *
from employee
order by hiredate, eno desc;

select *
from employee
order by ename;

/************************
 ******* 혼자해보기 ********
 ************************/

--1.덧셈연산자를 이용하여 모든사원에 대해서 300의 급여인상을 계산한 후 사원의 이름,급여,인상된급여 출력

select ename, salary, salary+300 as "인상된급여"
from employee;

--2.사원의 이름,급여,연간 총수입을 총수입이 많은것부터 작은순으로 출력 연간총수입:월급*12+상여금100

select ename, salary, salary*12 as "연간 총수입"
from employee
order by salary*12 desc;

--3.급여가 1200을 넘는(초과) 사원의 이름과 급여를 급여가 많은것부터 작은순으로 출력

select ename, salary
from employee
where salary>1200
order by salary desc;

--4.사원번호가 7788인 사원의 이름과 부서번호 출력

select ename, eno
from employee
where eno=7788;

--5.급여가 1000에서 1300 사이에 포함되지 않는 사원의 이름과 급여 출력

--1)
select ename, salary
from employee
where salary not between 1000 and 1300;
--2)
select ename, salary
from employee
where salary < 1000 or salary > 1300;
--3)*주의*우선순위 : not->and->or 이므로 괄호표시
select ename, salary
from employee
where not (salary >= 1000 and salary <= 1300);--*중요*부호를 사용할경우 초과, 미만은 or을 표시해야하지만. not을 붙이기때문에 부호값도 반대인 이상, 이하(포함)를 사용하고 중간표시(?)인 and를 붙여 not을 사용해야함
--헷갈리는(틀린) 예시)
select ename, salary
from employee
where not (salary > 1000 or salary < 1300);
--6.급여가 1000에서 1300 사이에 포함되는 사원의 이름과 급여 출력

--1)
select ename, salary
from employee
where salary between 1000 and 1300;
--2)
select ename, salary
from employee
where salary >= 1000 and salary <= 1300;
--3)
select ename, salary
from employee
where not (salary < 1000 or salary > 1300);--*중요*(위에것과반대)부호를 사용할경우 이상, 이하(포함)는 and를 표시해야하지만. not을 붙이기때문에 부호값도 반대인 초과,미만을 사용하고 중간표시인 or로 바꿔 not을 사용해야함

--7.1981년 2월 20일부터 1981년 5월 1일 사이에 입사한 사원의 이름,담당업무,입사일 출력

--1)
select ename, job, hiredate
from employee
where hiredate between '81/2/20'and'81/5/1';
--2)
select ename, job, hiredate
from employee
where hiredate between '1981-2-20'and'1981-5-1';
--3)
select ename, job, hiredate
from employee
where hiredate>='1981/2/20'and hiredate<='1981/5/1';

--8.부서번호가 20 또는 30에 속한 사원의 이름과 부서번호를 출력하되 이름을 영문자순(오름차순)으로 출력

--1)
select ename, dno
from employee
where dno in(20,30)
order by ename;
--2)
select ename, dno
from employee
where dno >= 20 and dno <= 30
order by ename;
--3)
select ename, dno
from employee
where dno = 20 or dno = 30
order by ename;

--9.사원의 급여가 1100-1300사이에 포함되고 부서번호가 20 또는 30인 사원의 이름을 영문자순(오름차순)으로 출력

--1)비트윈연산자 사용
select ename, salary, dno
from employee
where salary between 1100 and 1300 
and (dno = 20 or dno = 30)
order by ename;
--2)논리연산자
select ename, salary, dno
from employee
where salary >= 1100 and salary <= 1300 
and (dno = 20 or dno = 30)
order by ename;
--3)not연산자 사용
select ename, salary, dno
from employee
where not(salary < 1100 or salary > 1300 )
and (dno = 20 or dno = 30)
order by ename;
--4)비트윈연산자+in연산자 사용
select ename, salary, dno
from employee
where salary between 1100 and 1300
and (dno in(20,30))
order by ename;
--5)논리연산자+in
select ename, salary, dno
from employee
where salary >= 1100 and salary <= 1300 
and (dno in(20,30))
order by ename;
--6)not연산자+in
select ename, salary, dno
from employee
where not(salary < 1100 or salary > 1300 )
and (dno in(20,30))
order by ename;

--10.1981년도에 입사한 사원의 이름과 입사일 출력

--1)like사용
select ename, hiredate--오라클 기본날짜형식은 'yy/mm/dd'
from employee
where hiredate like '81%';--'1981%' 결과안나옴
--2)to_cahr사용(수나 날짜,'문자')
select ename,to_char(hiredate,'yyyy/mm-dd')
from employee
where to_char(hiredate,'yyyy/mm-dd') like '1981%';
--3)
select ename, hiredate
from employee
where hiredate>='1981-01-01' and hiredate<='1981-12-12';
--4)
select ename, hiredate
from employee
where hiredate between '1981-01-01' and '1981-12-12';
--5)
select ename, hiredate
from employee
where hiredate between '1981/01/01' and '1981/12/12';

--11.관리자(=상사)가 없는 사원의 이름과 담당업무

select ename, job
from employee
where manager is NULL;

--12.커미션을 받을 수 있는 자격이 되는 사원의 이름, 급여, 커미션을 출력하되. 급여 및 커미션 기준으로 내림차순 정렬*앞 조건 우선*

select ename, salary, commission
from employee
where commission is not null
order by salary desc, commission desc;

--13.커미션을 받을 수 있는 자격이 되는 세일즈맨의 이름, 급여,직업, 커미션을 출력하되. 급여 및 커미션 기준으로 내림차순 정렬*앞 조건 우선*

select ename, salary,job, commission
from employee
where job='SALESMAN' and commission is not null
order by salary desc, commission desc;

--14.커미션을 받을 수 있는 자격이되는 세일즈맨의 모든 정보를 출력하되.급여 및 커미션을 기준으로 내림차순정렬

select *
from employee
where job='SALESMAN' and commission is not null
order by 1 desc, 2 desc;

--15.이름의 세번째 문자가 R인 사원의 이름 표시

select ename
from employee
where ename like '__R%';

--16.이름에 A와 E를 모두 포함하고있는 사원의 이름 표시

select ename
from employee
where ename like '%A%' and ename like '%E%';

--17.담당업무가 사무원(CLERK)또는 영업사원(SALESMAN)이면서 급여가 1600,950또는 1300이 아닌 사원이름,담당업무,급여 출력

--1)
select ename, job, salary
from employee
where (job='CLERK' or job='SALESMAN') and salary not in (1600,950,1300);
--2)
select ename, job, salary
from employee
where job in ('CLERK','SALESMAN') 
and salary != 1600 and salary != 950 and salary != 1300;
--in 연산자가 편리함.--

--18.커미션이 500이상인 사원이름과 급여,커미션 출력

select ename, salary, commission
from employee
where commission >= 500;

/************************************************************************************************************************************/