--<북스-10장. 데이터 무결성과 제약조건>

--1.제약조건
--데이터 무결성 제약조건 : 테이블에 유효하지않은(부적절한) 데이터가 입력되는것을 방지하기 위해
--테이블을 생성할 때 각 컬럼에 대해 정의하는 여러 규칙

--<제약조건(5가지)>------------------------------------------------------------------------------------
--1. not null : null값을 허용하지 않겠다. - 컬럼에 각각에 넣을수있음. 테이블레벨에는 정의못함.

--2. unique : 중복을 허용하지 않겠다 -> 유일한 값(=고유키) *고유키의 특징 : 암시적으로 index 자동생성
--			  null은 unique 제약조건에 위반되지 않으므로 null은 중복 허용함.

--3. primary key(=PK=기본키) : not null제약조건 - null X
--						   + unique제약조건 - 중복X 고유키 : 암시적으로 index자동생성
--                         => null값 허용안함. 반드시 중복 허용안하는 유일한 값이어야함.

--4. foreign key(=FK=외래키=참조키) : 참조되는 테이블에 컬럼값이 항상 존재 해야함.
--예) 사원테이블(employee)의 dno(FK) -> 부서테이블(department)의 dno(PK)를 참조.
--        자식테이블                                      부모테이블
--                                 참조 무결성 - 테이블사이의 주종관계를 설정하기위한 제약조건
--어느테이블의 데이터가 먼저 정의되어야 하는가? -먼저 부모테이블부터 정의하고 자식테이블 정의
--위 예를 바탕으로 자식테이블의 참조되어있는 데이터(FK)는 부모테이블에서 반드시 기본키(PK) 또는 unique가 되어야함.

--5. check() : 저장가능한 데이터 범위나 조건을 저장하여 설정된 값 이외의 값이 들어오면 오류
--예) 나이를 입력할 때 음수를 넣으면안됨. number타입은 음수도 다 받기때문에 제약조건을 걸면됨.
-- => check(age>0)
--예) 급여를 표시 (급여가 0이나 -를 넣으면 안되기때문에)
-- => check(salary>0)

----------------------------------------------------------------------------------------------------
--책에서는 default제약조건이라 써있으나 제약조건으로 사용시 오류. default정의로 사용해야함.
--default 정의: 아무런 값을 업력하지 않았을 때 default로 설정한 값이 들어감.

--제약조건 : 컬럼 레벨 - 하나의 컬럼에 대해 모든 제약 조건을 정의.(default 정의 포함 6가지의 제약조건 중 원하는 조건을 정의)
--        테이블 레벨 - not null을 제외한 나머지 제약조건을 정의(default 정의 포함)
--테이블 생성할 때 사용함.

--<제약조건 이름 직접 지정할 때 형식>
--constraint 제약조건명
--constraint 테이블명_컬럼명_제약조건유형
--제약조건유형 적는법 not null:nn, unique:uk, primary key:pk, foreign key:fk
--제약조건이름을 지정하지않으면 자동생성됨

--컬럼레벨
--제약조건이름 명시하지않으면 자동생성
create table customer2(
id varchar2(20) unique,
pwd varchar2(20) not null,
name varchar2(20) not null,
phone varchar2(30),
address varchar2(100)
);

--제약조건이름 명시할때
create table customer2(
id varchar2(20)constraint customer2_id_uk unique,--unique대신 이렇게쓰면 제약조건이름을 명시하여 생성한것.
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_naem_nn not null,
phone varchar2(30),
address varchar2(100)
);

--id는 고유키이기 때문에 primary key로 해야함.
create table customer2 (
id varchar2(20) constraint costomer2_id_pk primary key,--컬럼 레벨
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_naem_nn not null,
phone varchar2(30),
address varchar2(100)
);

--테이블레벨
create table customer2 (
id varchar2(20) ,
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_naem_nn not null,
phone varchar2(30),
address varchar2(100),
constraint costomer2_id_pk primary key(id)--테이블 레벨
);

--사용이유 : 여러가지 컬럼을 기본키로 지정하기위해. 만약 밑 실행문에 id가없다면 이름을 기본키로 지정하는데,
--										같은 이름이 존재할 수 있으므로 name과 phone을 기본키로 지정.
create table customer2 (
id varchar2(20) ,
pwd varchar2(20) constraint customer2_pwd_nn not null,
name varchar2(20) constraint customer2_naem_nn not null,
phone varchar2(30),
address varchar2(100),
constraint costomer2_id_pk primary key(name, phone)--테이블 레벨
);

--생성한 테이블에 제약조건을 넣었는지 확인하는법 : user_constraintS 데이터 사전을 사용
select table_name, constraint_name--테이블 명과 제약조건 명만 출력
from user_constraintS--제약조건에 관련된 정보 중
where table_name in ('CUSTOMER2');--'테이블명'에 관한 
--★주의 : in('반드시 대문자로. 소문자 인식못함 오류는 안나지만 값이 안나옴.')

--1-1.not null제약조건 : 컬럼 레벨로만 정의
insert into customer2 values(null, null, null, '010-1111-2222', '대구 달서구');
--pwd, name 제약조건이 not null이기 때문에 null이 들어가선 안되므로 오류

--1-2.유일한 값만 허용하는 unique 제약조건 
-- primary key 제약조건은 not null+unique 이기때문에 실습을 위해 primary key를 사용한컬럼으로 확인(id)
insert into customer2 values('a1234', '1234', '홍길동', '010-1111-2222', '대구 달서구');
insert into customer2 values('a1234', '5678', '이순신', '010-1111-2222', '대구 달서구');
--id가 중복되기때문에 오류

--1-3.데이터 구분을 위한 primary key 제약조건 : 테이블의 모든 row를 구별하기위한 식별자 -> index 번호 자동생성됨

--1-4.참조 무결성을 위한 foreign key(FK=참조키=외래키) 제약조건
--사원테이블의 부서번호는 언제나 부서테이블에서 참조가 가능 : 참조 무결성
--자식:사원테이블(부서번호:FK) 부모:부서테이블(부서번호:반드시 PK or unique)

select * from department;--참조되는(부모)

--★★삽입(자식인 사원테이블에서)할 때 주의점
insert into employee (eno, ename, dno)--참조하는(자식)
values (8000, '홍길동', 50);
--부모테이블(department)에 부서번호(dno) 50이란 부서번호(dno)가 없기때문에 참조무결성에 위배.
--부서번호 50 입력하면 
--integrity constraint (SYSTEM.SYS_C007063) violated - parent key not found
--참조무결성 위배, 부모키를 발견하지 못했다는 오류메세지.
--이유? 사원테이블에서 사원의 정보를 새롭게 추가할 경우
--		사원테이블의 부서번호는 부서테이블의 저장된 부서번호중 하나와 일치하여야 함.
--		또는 null만 입력가능(단, null 허용하면)--참조 무결정 제약조건

--삽입 방법-1
insert into employee (eno, ename, dno)
values (8000, '홍길동', '');--(''=null) 단, dno가 null을 허용하면 사용가능.

select *
from employee
where eno=8000;

--삽입 방법-2 : 제약조건을 삭제하지않고 일시적으로 '비활성화'시킨 후 데이터 삽입 후 다시 '활성화'
--[1]user_constraint 데이터사전을 이용하여 constraint_name 알기
select table_name, constraint_type, constraint_name
from user_constraintS
where table_name in('EMPLOYEE');
--명시적으로 이름을 넣었지않았기 때문에 자동생성된 이름.constraint_type-P:PK, constraint_type-R:FK

--[2]제약조건 '비활성화'
alter table employee
disable constraint SYS_C007063;

--[3]삽입
--위에 만들어놓은것 삭제.
delete employee --from 생략가능
where eno=8000;--위에 eno=8000만들어 놓은것 때문에 fk비활성화 해도 pk 중복오류남.그래서 삭제하고 진행

insert into employee (eno, ename, dno)
values (8000, '홍길동', 50);

--삽입확인
select *
from employee
where eno=8000;

--[4]제약조건 '활성화'-- cannot validate (SYSTEM.SYS_C007063) - parent keys not found 오류남.
-- 					이유? 참조되는 부서테이블의 dno에 50이라는 부서번호가 없기때문에 삽입은 됐으나 제약조건 다시 활성화 불가능.
--					정말 50번부서에 사원을 넣고싶다면 부서테이블에 먼저 50이라는 부서를 만들어야 삽입가능.
--고로 삽입한 것 삭제해야 활성화가능
delete employee --from 생략가능
where eno=8000;

--활성화
alter table employee
enable constraint SYS_C007063;

--활성화 상태 확인
select table_name, constraint_type, constraint_name, status -- enable : 활성화, disable : 비활성화
from user_constraintS
where table_name in('EMPLOYEE');

--★삭제(부모인 부서테이블에서)할 때 주의점 : 자식테이블에서 참조되고있는 데이터가있으면 삭제불가능
--예)부서번호 50을생성하고 insert into employee (eno, ename, dno)values (8000, '홍길동', 50);을 넣었다면
--자식데이터를 먼저 삭제하고 부서테이블의 dno=50을 삭제해야 삭제가능.

--부모)실습을 위해 department2테이블 생성 department구조와 데이터 복사 ★주의 : 제약조건 복사안됨
create table department2
as
select *
from department;

--생성확인
select *
from department2;

--제약조건확인
select *
from user_constraintS
where table_name in('DEPARTMENT2');

--제약조건 추가방법1.
alter table department2
modify dno number(2) primary key;

--제약조건 추가방법2.
alter table department2
add constraint department2_dno_pk primary key(dno);

--자식)emp_second테이블 생성 - 참조되고 있어도 삭제가능하게
create table emp_second(
eno number(4) constraint emp_second_eno_pk primary key,
ename varchar2(10),
job varchar2(9),
salary number(7,2) default 1000 check(salary>0),
--(7,2)는 7자리까지 허용.소수둘째자리까지 라는 실수를 표현하겠다는 뜻 
--dafault 1000은 값을 안넣었을 시 1000이라는 기본값을 줌
--default 1000앞에 constraint emp_second_salary_df 라고 적을시 오류. default는 제약조건이아니기때문.
--default 1000뒤에 check (salary>0)으로 적을 시 오류가남.
-- dno number(2) constraint emp_second_dno_fk references department2 on delete cascade
--반드시 테이블레벨에서만 가능
--위 실행문 아니면
dno number(2)
constraint emp_second_dno_fk references department2(dno) 
on delete cascade--참조되고있을때 삭제 불가능
--references department2는 department2를 참조하겠다는 뜻.
--이때 참조받는 dno는 department2에서 기본키 or unique여야함.
--references department2만 적어도 foreign key라고 자동으로 들어감.
--★on delete cascade 를 붙이면 참조되고 있어도 삭제가 가능하게만듬. 단 연속적으로 부모와 자식 다삭제됨.
--말그대로 10번부서를 삭제하면 10번 부서의 정보가있는 employee테이블에 10번부서소속 정보도 다삭제됨
);

--on update cascade 연속적으로 부모와 자식 모두 데이터 갱신
--1. on delete cascade : 두 테이블을 연결해서 PK를 가지고있는 쪽의 값을 삭제하면 FK로 연결된값이 삭제
--즉 참조되는 부모테이블 값이 삭제되면 연쇄적으로 자식테이블이 참조하는 값 역시 삭제
--2. on delete set null : 부모테이블의 값이 삭제되면 해당 참조하는 자식테이블의 값들을 null로 설정

--생성확인
select *
from emp_second;

--실습을 위해 값입력
insert into emp_second values (1 ,'김' ,'영업' ,null ,30);
insert into emp_second values (2 ,'이' ,'조사' ,2000 ,20);
insert into emp_second values (3 ,'박' ,'운영' ,3000 ,40);
insert into emp_second values (4 ,'조' ,'상담' ,3000 ,20);
--1-6. default 정의 사용
insert into emp_second(eno, ename, job, dno) values (5 ,'김' ,'영업' ,30);
--salary default사용했기 때문에 확인차 넣음 방법1

insert into emp_second values (6 ,'조' ,'상담' ,default ,30);--default 사용방법2

--입력 확인
select *
from emp_second;

--삭제되는지 확인
--on delete cascade 사용안한것
drop table department;--department는 사원테이블에서 참조하는 상황이므로 삭제불가능(기본) ,turncate 명령어도 사용못함
truncate table department;
drop table department2;--on delete cascade와 관계없이 테이블은 삭제불가능 ,truncate명령어도 사용못함
truncate table department2;

delete department--부모에서 20번부서 삭제불가능
where dno=20;--dno20을 참조하고있어 삭제불가능.
--오류 이유 : on delete cascade 없으면 기본 NO ACTION==restrict
--        =>on delete restrict 와 같으나 기본값이기때문에 쓰나마나임

--on delete cascade 사용한것
delete department2--부모에서 20번부서 삭제가능
where dno=20;--참조하고있어도 삭제가능하게 on delete cascade로 만듬. 
--20번부서에 담겨있는 emp_second의 20번부서소속 사원의 정보 다 삭제.

--삭제 확인
select * from department2;--부모에서 삭제하면
select * from emp_second;--자식에서도 삭제됨(on delete cascade)

select *
from department2 natural join emp_second;

--제약조건 확인
select *
from user_constraintS
where table_name in('EMP_SECOND');

--제약조건 제거하는방법
alter table emp_second
drop primary key;

--원상복구
drop table emp_second;
drop table department2;

--1-5.check 제약조건 : 값의 범위나 조건지정
--currval, nextval, rownum 사용불가
--sysdate, user와 같은 함수 사용불가

--check(salary>0)이기때문에 음수넣으면 들어가는지 확인
insert into emp_second values (7, '조', '상담', -3000, 30);--check제약조건때문에 오류
insert into emp_second values (7, '조', '상담', 3000, 30);--양수는 입력됨

--입력확인
select *
from emp_second;

----------------------------------------------------------------------------------------------------
--2.제약조건 변경하기
--2-1.제약조건 추가 : alter table 테이블명 + add constraint 제약조건명 제약조건(컬럼);
--단, null 무결성 제약조건은 이 방법으로 추가못함.
--                    alter table 테이블명 + modify로 null상태로 변경가능
--                    alter table 테이블명 + modify 컬럼명 타입(크기) 제약조건;
--                    alter table 테이블명 + modify 컬럼명 타입(크기) null;
--default 정의할 때도 alter table 테이블명 + modify 컬럼명 타입(크기) default 기본값으로넣을값;

--앞 실습에서 테이블복사 했던것
select * from emp_copy;--제약조건은 복사안된상태
select * from dept_copy;--제약조건은 복사안된상태

--제약조건 확인 - 값이 안나옴(=복사하면 제약조건은 복사 안되있음)
select table_name, constraint_name
from user_constraintS
where table_name in('EMP_COPY', 'DEPT_COPY');

--기본키 제약조건 추가하기
--방법1)emp_copy 테이블에 eno를 primary key로 만들기
alter table emp_copy
add constraint emp_copy_eno_pk primary key(eno);

alter table dept_copy
add constraint dept_copy_dno_pk primary key(dno);
--제약조건명 명시한게 보기좋으므로 이걸쓰면 조회할때 보기가편하다.

--방법2)dept_copy 테이블에 dno를 primary key로 만들기
alter table emp_copy
modify eno number(4) primary key;

alter table dept_copy
modify dno number(2) primary key;
--하지만 실행문 적기에는 이것이 편하다

--제약조건 추가한것 확인
select table_name, constraint_name
from user_constraintS
where table_name in('EMP_COPY', 'DEPT_COPY');

--예)emp_copy테이블에 외래키=참조키(FK) 제약조건 추가하기
--방법1)
alter table emp_copy
add constraint emp_copy_dno_fk foreign key(dno) references dept_copy(dno);

select *
from dept_copy;--앞실습에서 부서번호를 지워버려 30부서만남았는데

select *
from emp_copy;--여기서는 부서번호가 10,20이 남아있어서 참조가 안되고있는 상황이다.

--사용하기위한 방법1. 30번부서를 제외한 모든 부서 제거
delete emp_copy
where dno != 30;

--사용하기위한 방법2. 부서를 다시 만들어준다 
--맨밑에서 원상복구하고 다시 실습하기위해 9장에서 만들경우 문제 9,10은 진행하지 않도록한다.
--문제 9,10번이 10,20,40번부서를 삭제하는 문제이므로
insert into dept_copy values(10,'ACCOUNTING','NEW YORK');
insert into dept_copy values(20,'RESEARCH','DALLAS');
insert into dept_copy values(40,'OPERATIONS','BOSTON');

--방법2를 사용하기위해 제약조건 제거
alter table emp_copy
drop foreign key;--참조키 제약조건 삭제안됨 이유?? 참조되어있어서?? 
--foreign key는 참조되있는 부모테이블의 primary key를 삭제하면 된다.하지만 다시 부모테이블에 primary key를 추가해야함.

--그냥 밑에서배운 cascade로 삭제하고 primary key를 다시 추가하자
alter table dept_copy
drop primary key cascade;

alter table dept_copy
add constraint dept_copy_dno_pk primary key(dno);

--제약조건 삭제, 추가한것 확인
select table_name, constraint_name
from user_constraintS
where table_name in('EMP_COPY', 'DEPT_COPY');

--방법2)
alter table emp_copy
modify dno number(2) references dept_copy(dno);--이 실행문은 실행이되나 
--선생님이적어준 foreign key(dno) references dept_copy(dno);는 실행이안됨
--상위키를 찾을수없다고 나옴.방법1은 됨  이유??테이블생성에도 foreign key가 있으니 실행이안됬음.빼면됨
--add사용하는게 나은거같음

--예)not null 제약조건 추가하기
alter table emp_copy
modify ename constraint emp_copy_ename_nn not null;
--add대신 modify사용해야함

--제약조건 추가한것 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('EMP_COPY');

--예)default 정의 추가
alter table emp_copy
modify salary default 500;
--add대신 modify사용해야함

--제약조건 추가한것 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('EMP_COPY');--테이블1개면 in 대신 = 사용해도됨

--두 테이블 모두 제약조건 추가한것 확인
select table_name, constraint_name
from user_constraintS
where table_name in('EMP_COPY', 'DEPT_COPY');

--예)salary에 check 제약조건 추가하기
alter table emp_copy
add constraint emp_copy_salary_check check(salary>1000);
--이미 들어가있는 데이터 중에 1000보다 작은 급여가 있으므로 제약조건에 위배되어 오류발생

--check제약조건 500보다 크고 10000보다 작게
alter table emp_copy
add constraint emp_copy_salary_check check(salary>500 and salary<10000);

--제약조건 추가한것 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('EMP_COPY');

--예)dno에 check제약조건 추가
alter table dept_copy
add constraint dept_copy_dno_check check (dno in (10,20,30,40,50));

--오류나는것. 문법상오류이므로 주의
alter table dept_copy
add constraint dept_copy_dno_check check dno in (10,20,30,40,50);

--제약조건 추가한것 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('DEPT_COPY');

--2-2.제약조건 제거
--외래키 제약조건에 지정되어있는 부모테이블의 기본키 제약조건을 제거하려면
--자식 테이블의 참조무결성 제약조건을 먼저 제거한 후 제거하거나
--cascade 옵션 사용 : 제거하려는 컬럼을 참조하는 참조 무결성 제약조건도 함께 제거
alter table dept_copy
drop primary key;--emp_copy에 참조하고있는 상황이라 제거불가

alter table emp_copy
drop primary key cascade;--참조하는 자식테이블의 제약조건도 제거

--제약조건 제거한것 확인
select table_name, constraint_name
from user_constraintS
where table_name in('EMP_COPY', 'DEPT_COPY');

--예)not null 제약조건 제거
alter table emp_copy
drop constraint emp_copy_ename_nn;

--제약조건 제거한것 확인
select table_name, constraint_name
from user_constraintS
where table_name in('EMP_COPY', 'DEPT_COPY');

--제약조건 활성화 및 비활성화
--alter table 테이블명 + disable constraint 제약조건명
--제약조건을 삭제하지않고 일시적으로 비활성화
--위 내용참조

--원상복구 후 9장 혼자해보기에서 다시생성후 위에서부터 다시 실행하기
drop table emp_copy;
drop table dept_copy;

/************************
 ******10장-혼자해보기******
 ************************/
--문제1.employee테이블의 구조만 복사하여 emp_sample이란 이름의 테이블을 만드시오
--사원테이블의 사원번호 칼럼에 테이블레벨로 primary key 제약조건을 지정하되 제약조건이름은 my_emp_pk로 지정하시오.
--[1]employee테이블 구조만 복사
drop table emp_sample;--원상복구

create table emp_sample
as
select *
from employee
where 0=1;

--테이블생성확인
select *
from emp_sample;

--[2]테이블레벨로 primary key 제약조건을 지정
alter table emp_sample
add constraint my_emp_pk primary key(eno);

--컬럼레벨로 primary key 제약조건을 지정하는법
alter table emp_sample
modify eno number(4) primary key;

--제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('EMP_SAMPLE');

--문제2.department테이블의 구조만 복사하여 dept_sample이란 이름의 테이블을 만드시오
--부서테이블의 부서번호 칼럼에 테이블레벨로 primary key 제약조건을 지정하되 제약조건이름은 my_dept_pk로 지정하시오.
drop table dept_sample;--원상복구

create table dept_sample
as
select *
from employee
where 0=1;

--테이블생성확인
select *
from dept_sample;

--[2]테이블레벨로 primary key 제약조건을 지정
alter table dept_sample
add constraint my_dept_pk primary key(dno);

--컬럼레벨로 primary key 제약조건을 지정하는법
alter table dept_sample
modify dno number(2) primary key;

--제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('DEPT_SAMPLE');

--문제3.사원테이블의 부서번호 칼럼에 존재하지않는 부서의 사원이 배정되지않도록 외래키 제약조건을 지정하되=부서번호를 참조시켜라
--제약조건의 이름은 my_emp_dept_fk로 지정하시오.
alter table emp_sample
add constraint my_emp_dept_fk foreign key(dno) references dept_sample(dno);
--반드시 부모데이터를 먼저 삽입한 후 자식의 참조하는 데이터 참조
--만약 emp_sample에 데이터가 있고 dept_sample에 데이터가 없으면 안됨.
--지금은 둘다 데이터가 없기때문에 위 실행문이 되지만
--책에서는 references department(dno);쓴 이유는 emp_sample에 데이터가 있다는 가정?저자가 적은거라 모름.

--제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('EMP_SAMPLE');

select *
from emp_sample natural join dept_sample;

--문제4.사원테이블의 커미션칼럼에 0보다 큰값만을 입력할수 있도록 제약조건을 지정하시오
alter table emp_sample
add constraint emp_commission_check check(commission>0);

--제약조건 확인
select table_name, constraint_name
from user_constraintS
where table_name = ('EMP_SAMPLE');

/**************************************************************************************************/