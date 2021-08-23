/*
데이터베이스 사용자는 오라클계정과 같은의미
<오라클에서 제공하는 사용자 계정>
1.sys : 시스템유지, 관리, 생성 모든권환, 오라클시스템 총관리자, sysdba권한
2.system : 생성된 DB운영, 관리.'관리자'계정.SYSOPER권한
3.hr : 처음 오라클 사용하는 사용자를 위해 실습위한 '교육용'계정
*/

--3.2데이터베이스 구축하기
--(1).데이터베이스 생성
--(2).사원정보와 소속된 부서정보, 급여정보 저장할 테이블

--명령어는 대,소문자구분없음. 대신 명칭같은것은 대,소문자구분. 나중에 써치할때 대문자는 대문자만 찾음

--테이블 삭제

drop table employee;--자식테이블 : 부모테이블의 dno 참조
drop table department;--부모테이블 : ★주의.참조되는 상황에서 삭제불가능(자식부터 삭제)
drop table salgrade;

--테이블 구조 파악

--desc department; sql*plus:run sql에서 실행하기-> conn system/1234 -> desc department;

--부서정보 테이블:부서번호,부서명,지역명

create table department(
dno number(2) primary key,
dname varchar2(14),
loc varchar2(13)
);

insert into department values(10,'ACCOUNTING','NEW YORK');--명령어는 대,소문자 구분x
insert into department values(20,'RESEARCH','DALLAS');--괄호안의 영단어는 구분o 대문자or소문자 한가지로 사용
insert into department values(30,'SALES','CHICAGO');--varchar2는 ''안에써야함
insert into department values(40,'OPERATIONS','BOSTON');

--사원정보 테이블:사원번호(*primary key-기본키,중복x,유일),이름,업무명,해당사원의 상사번호,입사일,급여,커미션,부서번호

create table employee(--departdent 테이블이있어야 실행되므로 department 먼저실행(department테이블을 참조하는상황)
eno number(4) primary key,
ename varchar2(10),
job varchar2(15),
manager number(4),--emploryee테이블의 eno와 연결
hiredate date,
salary number(7,2),--소수점을 포함한 전체자리수 7자리,소수점이하 2자리 수(=실수)
commission number(7,2),
dno number(2) references department--department 테이블의 dno와 연결.
);

insert into employee values(7369,'SMITH','CLERK',7902,'1980-12-17',1300,NULL,20);--date는 to_date(yyyy_mm_dd)or'yyyy-mm-dd'로 표시
INSERT INTO EMPLOYEE VALUES(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981', 'dd-mm-yyyy'),1100,150,30);
INSERT INTO EMPLOYEE VALUES(7521,'WARD','SALESMAN',7698,to_date('22-2-1981', 'dd-mm-yyyy'),1150,200,30);
INSERT INTO EMPLOYEE VALUES(7566,'JONES','MANAGER',7839,to_date('2-4-1981',  'dd-mm-yyyy'),1095,NULL,20);
INSERT INTO EMPLOYEE VALUES(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981', 'dd-mm-yyyy'),1115,200,30);
INSERT INTO EMPLOYEE VALUES(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981',  'dd-mm-yyyy'),1210,NULL,30);
INSERT INTO EMPLOYEE VALUES(7782,'CLARK','MANAGER',7839,to_date('9-6-1981',  'dd-mm-yyyy'),1100,250,10);
INSERT INTO EMPLOYEE VALUES(7788,'SCOTT','ANALYST',7566,to_date('13-07-1987', 'dd-mm-yyyy'),985,270,20);
INSERT INTO EMPLOYEE VALUES(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),1800,700,10);
INSERT INTO EMPLOYEE VALUES(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981',  'dd-mm-yyyy'),1120,NULL,30);
INSERT INTO EMPLOYEE VALUES(7876,'ADAMS','CLERK',7788,to_date('13-07-1987', 'dd-mm-yyyy'),1100,180,20);
INSERT INTO EMPLOYEE VALUES(7900,'JAMES','CLERK',7698,to_date('3-12-1981', 'dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMPLOYEE VALUES(7902,'FORD','ANALYST',7566,to_date('3-12-1981', 'dd-mm-yyyy'),1370,350,20);
INSERT INTO EMPLOYEE VALUES(7934,'MILLER','CLERK',7782,to_date('23-1-1982', 'dd-mm-yyyy'),1200,NULL,10);

--급여정보 테이블:급여등급,급여하한값,급여상한값

create table salgrade(
grade number,
losal number,
hisal number
);

insert into salgrade values(1,700,900);
insert into salgrade values(2,901,1100);
insert into salgrade values(3,1101,1300);
insert into salgrade values(4,1301,1500);
insert into salgrade values(5,1501,1900);

--테이블 조회

select * from department;
select * from employee;
select * from salgrade;--테이블 속 모든 정보조회

select eno,ename
from employee;--테이블속 칼럼정보조회

select eno,salary,salary*12
from employee;

/*
 * 산술 연산에 null을 사용하는경우에는 특별한 주의가 필요함
 * null은 '미확정','알수없는 값'이란 의미.연산,할당,비교 불가능
 */

select eno,salary,commission,salary*12+commission
from employee;

select commission
from employee;

/*
 *커미션을 더한 연봉구하기
 *nvl()함수 사용하여 위의문제해결
 */

select eno,salary,commission,salary*12+NVL(commission,0)
from employee;

/*
 *커미션에 null보기싫을때 0으로바꾸기
 */

select eno,salary,NVL(commission,0),salary*12+NVL(commission,0)
from employee;

--데이터상은 그대로 null, 화면출력에만 0으로표기함.

/*
 * 알아보기쉽게 (eno를 이름, salary를 연봉)이름변경법(별칭)
 * 1.컬럼명 별칭
 * 2.컬렴명 as 별칭
 * 3.컬럼명 as "별 칭"
 * 반드시 ""해야하는 규칙
 * 별칭글자 사이에 공백,특수문자 추가 또는 대소문자 구분
 */

select eno 이름,salary*12 as "연 봉",salary*12+NVL(commission,0) as "연봉+커미션"
from employee;

--as 생략가능,띄어쓰기하려면 "표기",특수문자,기호 사용시 "표기"

/*
 * 중복되는것 한번씩만 출력하기
 * select distinct 칼럼명
 */

select dno
from employee;

select distinct dno
from employee;

/*
 *DUAL:가상테이블을 이용해 결과값을 하나만 출력하고싶을때
 */

select * from dual;

--사용법

select sysdate from employee;--15행(사원수 만큼 뜸)<sysdate:오늘날짜>
select sysdate from dual;

/************************************************************************************************************************************/