--6장--<테이블 join하기>
--1.join
--1-1)cross join(=카디시안 곱)

select *
from employee;--컬럼수8개, 행수 15개

select *
from department;--컬럼수3개, 행수 4개

select *
from employee, department
order by 1;--컬럼수 11개, 행수 60개
--join결과 : 컬럼수(11)=사원테이블의 컬럼수(8)+부서테이블의 컬럼수(3)
--		     행수(60)=사원테이블의 행수(15)X부서테이블의 행수(4) (=카디시안 곱)
--         행수 이유 : 사원테이블의 사원 1명 당X부서테이블의 행수(4) 로 출력되었기 때문.

--1-2)join의 유형
--오라클 8i 이전 join : equi join, non-equi join, outer join(왼쪽, 오른쪽), self join
--오라클 9i 이후 join : cross join, natural join, join using, outer join(왼쪽, 오른쪽, full(=둘다))
--오라클 9i 부터 ANSI 표준 SQL join을 사용 : 현재 대부분의 상용 데이터베이스 시스템에서 사용.
--                                   다른 DBMS(데이터베이스 관리시스템)와 호환이 가능하기 때문에 ANSI 표준 join에 대해서 확실히 학습해야함.

--<4가지 join문 비교>--------------------------------------------------------------------------------------------------------------------
--equi join : 동일한 이름과 데이터 유형을 가진 컬럼으로 조인
--1. , ~ where join
--조인결과 중복된 컬럼은 제거안됨 -> 별칭을 사용하여 어느 테이블의 컬럼인지 반드시 구분해야함.
select 컬럼명1, 컬럼명2--중복되는 컬럼은 반드시 별칭.컬럼명 (예)e.dno
from 테이블명1, 테이블명2--별칭 사용
where--★join 조건(별칭 사용)
and--★검색 조건--★★문제점:논리연산자로 인식해서 검색조건을 join조건+and(논리연산자)+join조건 으로 인식해 오류가날 가능성이 있다.(이유:not->and->or 의 우선순위 때문에) 
--             ★★해결법:검색조건에 ()를 사용하여 우선순위를 변경한다.=>and(검색조건)
--예)
--where e.dno=d.dno 
--and e.dno=10 or d.dno=40--이경우 and먼저 연산하기때문에 and가 검색조건이아닌 연산자로 인식됨. or이 아닌 and일 경우도 마찬가지.앞and부터 연산
--예문 해결)
--where e.dno=d.dno 
--and (e.dno=10 or d.dno=40)--만약 검색조건이 and e.dno=10 이것이라면 괄호안쳐도 된다.

--2.natural join : (여러개의 테이블)자동으로 동일한 이름과 데이터 유형을 가진 컬럼(★★단,1개만 있을때 사용하는것을 권장)으로 조인
---★동일한 이름과 데이터유형을 가진 컬럼이 2개이상 있어도 조인은 되나 문제가 발생할 수 있다.
--문제발생 이유? 예) employee의 dno와 department의 dno : 동일한 이름과 데이터유형, ★dno가 둘다 부서번호로 의미가 같다.
--				만약 employee의 manager(각 사원의 상사를 의미하는 사원번호)가 있고 
--					department의 manager(각 부서의 부장을 의미하는 사원번호)가 있다면
--					동일한 이름과 데이터유형을 가졌지만 manager의 의미가 다르면 원하는 결과가 출력안됨

-- 같은 컬럼이 있으면 자동으로 조인이 되기때문에 조인조건을 사용 안해도됨.(조인결과 중복된 컬럼을 제거)

select 컬럼명1, 컬럼명2 --별칭 사용시 오류
from 테이블명1 natural join 테이블명2--자동으로 동일한 이름과 데이터유형을 가진 컬럼으로 조인.(조인 결과는 중복된 컬럼 제거(=하나로 표시)).별칭사용안함(권장)
--조인조건 없어도 됨.
where --★검색 조건 

--3.join~using :동일한 이름과 데이터 유형을 가진 컬럼(★★1개 이상 있을때 사용)으로 조인+"이름은 동일, 데이터유형이 다른 컬럼"을 조인(조인결과 중복된 컬럼을 제거)

select 컬럼명1, 컬럼명2--만약 동일한 이름이지만 의미가 다른 컬럼이 있다면 별칭을 사용하여 구분함. 예)위의 natural join의 예에 있는 manager컬럼
--																			 employee는 e로 별칭, department는 d로 별칭 -> e.manager, d.manager로 검색
from 테이블명1 join 테이블명2--별칭사용,생략가능
using (동일한 컬럼명1, 동일한 컬럼명2...)--★join 조건
where --★검색 조건

--따라서 같은이름,타입,의미의 컬럼이 하나이면 natural join을 사용
--두개 이상이면 가독성이 좋은 join~using을 사용하는것을 권장.
--natural join은 컬럼 두개이상도 가능하지만 같은이름,타입 다른의미의 컬럼이 있다면 원하는값 출력안됨
--이럴경우에는 join using을 사용하여 별칭을 주어 구분

--4.join~on : 동일한 이름과 데이터 유형을 가진 컬럼으로 조인+"임의의 조건을 지정하거나 조인할 컬럼을 지정할 때 ON절을 사용"(조인결과 중복된 컬럼은 제거안됨)

select 컬럼명1, 컬럼명2
from 테이블명1 join 테이블명2--별칭사용,생략가능
on --★join 조건--별칭사용
where --★검색 조건
--equi join에 나타난 문제가 발생하지 않으므로 검색조건에서 ()사용 안해도된다.

--방법1과 방법4의 조인결과 중복된 컬럼 제거안함
--★★방법1과 방법4 : 아이디와 id처럼 컬럼명이 달라도 join 가능함 (예) e.아이디=d.id (단, 타입이 같아야함) => 동일하지않은 이름과 동일한 데이터유형

--방법2와 방법3 : 컬럼명이 다르면 join 불가능
--------------------------------------------------------------------------------------------------------------------------------------

--2-1)equi join(=동일join=등가join) : 두 테이블에 공통으로 존재하는 동일한 컬럼명을 기준으로 join

select 컬럼명1, 컬럼명2
from 테이블명1, 테이블명2
where --평상시에는 프롬에 테이블이 하나가 들어가므로.검색 조건
--                ★★테이블이 두개이상이 들어가면 join문이 되므로.join 조건
and --★★join문에서 검색 조건

select 컬럼명 1, 컬럼명2
from 테이블명1
where--검색 조건

--각 사원들이 소속된 부서정보 얻기(equi join 사용)

--별칭사용

select *
from employee e, department d--dno를 기준으로 join해야하기 때문에 구분하기위해 테이블명에 별칭을붙여줌.안붙이면?
where e.dno=d.dno--별칭안붙이면 employee.dno=department.dno 로 써야함. 별칭을 사용하면 가독성이좋다. ★해당 SQL명령문 내에서만 유효.
order by 1;--equi join

--별칭미사용

select *
from employee, department
where employee.dno=department.dno--테이블명 사용
order by 1;--equi join

--문제.각 사원들의 정보중에서 사원번호, 사원명, 부서번호, 부서명 얻기
--사원테이블과 부서테이블을 join(부서번호:두 테이블의 같은컬럼)

select eno, ename, e.dno, dname --두 테이블에서 같은 컬럼을 출력하고자 하면 두 테이블중 하나의 컬럼만 출력하면 됨.출력할땐 반드시 별칭.컬럼 을써야함.(e.dno or d.dno)
from employee e, department d
where e.dno=d.dno
order by 1;

--문제.사원번호가 7788인 사원이 소속된 사원번호, 사원명, 부서이름 얻기(equi join 사용)

select e.eno, e.ename, d.dname--별칭 생략 가능. 두 테이블에서 같은 컬럼이 아니기때문.
from employee e, department d
where e.dno=d.dno--join 조건
and eno=7788;--검색 조건(사원번호가 7788)

--2-2)natural join : 동일한 이름과 데이터 유형을 가진 컬럼이 존재해야만 사용 가능.
--                 ★★동일한 이름과 데이터 유형을 가진 컬럼이 단 1개만 있어야 사용 가능.
--                  조인조건 입력안해도 자동으로 동일한 이름과 데이터유형을 가진 컬럼으로 조인

--join문 아닐시
select 컬럼명1, 컬럼명2
from 테이블명1
where--★검색 조건

select *
from employee natural join department--같은 컬럼이름이 있으면 자동으로 하나의 컬럼으로 출력하게해줌.

--문제.사원번호가 7788인 사원이 소속된 사원번호, 사원명, 부서이름 얻기(natural join 사용)

select eno, ename, dname
from employee natural join department--자동으로 하나의 컬럼으로 출력해주기 때문에 테이블명에 별칭을 붙일 필요가 없다.
where eno=7788;--★검색 조건

select e.eno, e.ename, d.dname--중복되지 않은 컬럼들은 별칭 사용 가능.하지만 가독성이 떨어지고 개발자실수가 발생할 가능성이 있음.
from employee e natural join department d--별칭을 사용해도 결과에 영향을 미치지 않는다.
where e.eno=7788;--★검색 조건 --결과가 employee의 eno밖에 없기때문에(=다른 테이블에 중복되는 eno(컬럼)가 없기때문에) 별칭 생략해도 무방하다.

--+위 문제에 부서번호까지 얻고자한다면

select eno, ename, e.dno,e dname--이미 natural조인으로 하나의 컬럼만 나오게 했기때문에 별칭(or 테이블명).컬럼명 사용하면 오류가남.
from employee natural join department 
where eno=7788;

--+(위 실행문 해결)출력할때.

select eno, ename, dno, dname--동일한 이름과 같은 데이터유형을 가진 컬럼은 2개중 1개를 제거했기 때문에 테이블안의 컬럼명을 출력 하고자하면 오류가남.그래서 컬럼명만 사용.
from employee natural join department
where eno=7788;

--2-3)join~using(컬럼) : 동일한 이름이지만, 데이터유형이 다를 경우(이런게있나..물어보기) 사용
--★동일한 이름과 유형을 가진 컬럼이 1개 일 경우 : natural join
--★동일한 이름과 유형을 가진 컬럼이 2개 이상일 경우 : join~using
--(조인 결과는 중복된 컬럼제거)

--여러 테이블간 조인할 경우 natural join과 using join 모두 사용 가능할 때
--가독성이 좋은 using join 을 이용한 방법을 권한다.

--문제.사원번호가 7788인 사원이 소속된 사원번호, 사원명, 부서이름 얻기(join~using 사용)

select eno, ename, dname
from employee join department
using (dno)--조인할 기준(같은컬럼명)
where eno=7788;

--+위 문제에 부서번호까지 얻고자 한다면

select eno, ename, dno, dname--natural join과 마찬가지로dno에 별칭사용x 중복된 컬럼을 제거하기 때문.
from employee e join department d--별칭생략가능.
using (dno)
where eno=7788;

--2-4)join~on : 동일한 이름과 데이터 유형을 가진 컬럼으로 조인+"임의의 조건을 지정하거나 조인할 컬럼을 지정할 때 ON절을 사용"(조인결과 중복된 컬럼은 제거안됨)
select 컬럼명1, 컬럼명2
from 테이블명1 join 테이블명2--별칭사용,생략가능
on --★join 조건--별칭사용
where --★검색 조건
--equi join에 나타난 문제가 발생하지 않으므로 검색조건에서 ()사용 안해도된다.

--문제.사원번호가 7788인 사원이 소속된 사원번호, 사원명, 부서이름 얻기(join~on 사용)

select eno, ename, dname
from employee e join department d
on e.dno=d.dno
where eno=7788;

--★★조인결과 중복된 컬럼은 제거안될 시 : 반드시 별칭사용
--★★조인결과 중복된 컬럼은 제거될 시 : 별칭 사용,생략 가능 

--★문제.위 4가지 방법으로 '사원번호가 7788'인 사원이 소속된 '사원번호, 사원이름, 부서번호, 소속부서이름'얻기

--1.equi join --별칭사용. 두 테이블 ,로 조인. 중복제거안됨

select eno, ename, e.dno, dname
from employee e, department d
where e.dno=d.dno--조인조건
and eno=7788;--검색조건

--2.natural join --별칭사용X. 두 테이블 사이 natural join 사용하면 끝. 자동중복제거

select eno, ename, dno, dname
from employee natural join department
where eno=7788;--검색조건

--3.join~using --별칭사용X. using(기준컬럼). 자동중복제거

select eno, ename, dno, dname
from employee join department
using (dno)
where eno=7788;--검색조건

--4.join on --별칭사용. equi join과 달리 ,말고 join사용. 중복제거안됨

select eno, ename, e.dno, dname
from employee e join department d
on e.dno=d.dno--조인조건 --등가조인=(같다)
where eno=7788;--검색조건

--★★1번과4번 join 비슷. 2번과3번 join 비슷. 차이점공부. 조건공부.

--------------------------------------------------------------------------------------------------------------------------------------

--3.non-equi join(=비등가조인) : 조인 조건에서(=where절)'=(같다)' 연산자 이외 연산자를 사용할 때. 조인되는 테이블중 컬럼이 중복되는것이 없을 때 사용
--                예) < , > , >= , <= , between ~ and ~

--문제. 사원별로 급여등급 출력(non-equi join)

--1)동일한 컬럼이 있는지 급여등급 테이블 출력해보기

select *
from salgrade;

--2)문제. 사원별로 사원이름, 급여, 급여등급 출력
--사원이름, 급여 : 사원(employee)테이블
--급여등급 : 급여(salgrade)테이블

--방법1.
select ename, salary, grade as "급여등급"
from employee join salgrade --별칭 사용 안함.이유?중복되는 컬럼이 없으므로.
on salary between losal and hisal; --조인조건.

--방법2.
select ename, salary, grade as "급여등급"
from employee join salgrade
on salary >= losal and salary <= hisal
where salary < 1000 or salary > 1200;--검색조건 추가. 급여가 1000미만이거나 1200초과한것.

--equi join으로 조인 : 반드시 ()해야하는 불편함이 발생.()안하면 결과가 달라짐.
select ename, salary, grade as "급여등급"
from employee , salgrade --별칭 사용 안함.이유?중복되는 컬럼이 없으므로.
where salary >= losal and salary <= hisal
and (salary < 1000 or salary > 1200);--괄호를 안 쓸 경우 출력결과가 이상하게나옴. 실수할 가능성이 있기 때문에 join~on을 사용하는것이 좋다.
--결과가 다른이유? 우선순위가 and->or 따라서 ()로 우선순위를 변경하여 해결.

--★★중복 컬럼이 있으면 natural join(동일한이름,같은데이터유형)을 사용(단, 2개이상일경우에는 join~using(동일한이름이지만 다른 데이터유형도 가능)사용)
--★★중복 컬럼이 없으면 join~on을 사용하는것이 좋다.

--3개의 테이블 조인하기

--문제. 사원의 이름과 소속된 부서명, 급여, 급여등급 조회(=출력)
--사원이름, 급여 : 사원(employee)테이블
--부서명 : 부서(department)테이블
--급여등급 : 급여(salgrade)테이블
--사원 테이블과 부서테이블은 동일한 컬럼이 있다.(dno)
--사원테이블과 부서테이블은 등가조인-> 결과테이블과 급여테이블을 비등가조인

--방법1. equi join 사용
select ename, dname, salary, grade as "급여등급"
from employee e, department d, salgrade
where e.dno=d.dno
and salary between losal and hisal;

--방법2. join~on 사용
select ename, dname, salary, grade as "급여등급"
from employee e join department d
on e.dno=d.dno
join salgrade
on salary between losal and hisal; --join뒤에 바로 조인조건인 on을 써주고 그결과를 다시 join~on으로 조인해야하기 때문에 이렇게 사용해야함.

--방법3. natural join 후 join~on
select ename, dname, salary, grade as "급여등급"
from employee natural join department join salgrade
on salary between losal and hisal;

--[4가지 특징 결과]
--1.등가조인은 natural join사용
--2	-1. 2개의 테이블을 비등가조인 할 때 : join on 사용(equi join 사용해도 되나 검색조건에 ()유의(프로그래머의 실수 발생 가능성이 큼))
-- 	-2. 3개의 테이블을 비등가조인 할 때 : equi join 사용(편리)
--3. 2개의 테이블은 등가조인, 그결과와 다른테이블은 비등가조인 할 때 : natural join+join on이 편한거 같다.

--------------------------------------------------------------------------------------------------------------------------------------

--4.self join : '하나의 테이블'에 있는 컬럼끼리 연결해야 하는 조인이 필요한 경우.

--문제.'SCOTT'이란 사원의 매니저 이름 검색

select *
from employee;--scott의 매니저(eno로 표시)와 매니저이름의 곂치는 부분확인.=>eno로 조건을주면 매니저 이름이나옴

select *
from employee e, employee m
where e.manager=m.eno
order by 1;--조인 기준 확인.(e 테이블의 manager(eno로 표시) m 테이블의 eno)

select e.ename as "사원이름", m.ename as "직속상관"
from employee e, employee m --별칭을 사용해 구분해야함.
where e.manager=m.eno--조인조건
and e.ename='SCOTT'; --검색조건

select e.ename ||'의 직속 상관은'|| m.ename ||'입니다.'
from employee e, employee m --별칭을 사용해 구분해야함.
where e.manager=m.eno --조인조건
and e.ename='SCOTT'; --검색조건

select e.ename ||'의 직속 상관은'|| m.ename ||'입니다.'
from employee e, employee m--별칭을 사용해 구분해야함.
where e.manager=m.eno --조인조건
and m.ename='SCOTT'; --검색조건//잘못된경우. 직속상관이 scott인 사원이름이 구해짐.

select e.ename ||'의 직속 상관은'|| m.ename ||'입니다.'
from employee e, employee m --별칭을 사용해 구분해야함.
where e.manager=m.eno; --조인조건//검색조건을 안붙이면 모든 사원의 직속상관이 나온다. 직속상관이없는 king은 제외

--------------------------------------------------------------------------------------------------------------------------------------

--5.outer join
--equi join의 조인조건에서 기술한 컬럼에 대해 두 테이블 중 어느 한쪽 컬럼이라도
--null이 저장되어 있다면 '='의 비교결과가 거짓이 됨.
--그래서 null값을 가진 행은 조인 결과로 얻어지지 않음.

--'KING'에 대한 직속상관 출력하기.NULL값이라도 NULL출력하기
select e.ename ||'의 직속 상관은'|| m.ename ||'입니다.'
from employee e, employee m --별칭을 사용해 구분해야함.
where e.manager=m.eno --조인조건
and e.ename='KING'; --NULL이므로 결과로는 출력되지 못함.

select e.ename ||'의 직속 상관은'|| m.ename ||'입니다.'
from employee e, employee m --별칭을 사용해 구분해야함.
where e.manager=m.eno --조인조건
and m.ename='KING'; --테이블별칭을 실수로 반대로 적을 경우 직속상관이 KING인 사원이나옴.(=결과값이바뀜)

--위 방법으로는 해결하지 못함.
--방법1.outer join 사용 (left/right/full)
select e.ename ||'의 직속 상관은'|| m.ename ||'입니다.'
from employee e left outer join employee m --별칭을 사용해 구분해야함.//"오른쪽 테이블에 null값이 있더라도 표시하겠다"란의미
on e.manager=m.eno --조인조건 outer join은 조인조건이 on
where e.ename='KING';

--방법2.equi join + null값을 출력하고자 하는곳에(+)//외부평가할 때 외우기쉬운 이 방법 사용하는게 좋음.
select e.ename ||'의 직속 상관은'|| m.ename ||'입니다.'
from employee e, employee m --별칭을 사용해 구분해야함.
where e.manager=m.eno(+) --조인조건 : null값을 출력하는 곳에(+)
and e.ename='KING';

/************************************************************************************************************************************/