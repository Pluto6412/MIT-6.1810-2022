
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <match>:

void
match(char *path, char *fileName)
{
  char *p = path;
  while(*p != 0) {
   0:	00054783          	lbu	a5,0(a0)
   4:	c7b9                	beqz	a5,52 <match+0x52>
{
   6:	7179                	addi	sp,sp,-48
   8:	f406                	sd	ra,40(sp)
   a:	f022                	sd	s0,32(sp)
   c:	ec26                	sd	s1,24(sp)
   e:	e84a                	sd	s2,16(sp)
  10:	e44e                	sd	s3,8(sp)
  12:	1800                	addi	s0,sp,48
  14:	89aa                	mv	s3,a0
  16:	892e                	mv	s2,a1
  char *p = path;
  18:	84aa                	mv	s1,a0
    //printf("%s==flag\n", p);
    if(strcmp(p, fileName) == 0) {
  1a:	85ca                	mv	a1,s2
  1c:	8526                	mv	a0,s1
  1e:	00000097          	auipc	ra,0x0
  22:	290080e7          	jalr	656(ra) # 2ae <strcmp>
  26:	c511                	beqz	a0,32 <match+0x32>
      printf("%s\n", path);
      return;
    }
    p++;
  28:	0485                	addi	s1,s1,1
  while(*p != 0) {
  2a:	0004c783          	lbu	a5,0(s1)
  2e:	f7f5                	bnez	a5,1a <match+0x1a>
  30:	a811                	j	44 <match+0x44>
      printf("%s\n", path);
  32:	85ce                	mv	a1,s3
  34:	00001517          	auipc	a0,0x1
  38:	a4450513          	addi	a0,a0,-1468 # a78 <malloc+0x148>
  3c:	00001097          	auipc	ra,0x1
  40:	83c080e7          	jalr	-1988(ra) # 878 <printf>
  }
}
  44:	70a2                	ld	ra,40(sp)
  46:	7402                	ld	s0,32(sp)
  48:	64e2                	ld	s1,24(sp)
  4a:	6942                	ld	s2,16(sp)
  4c:	69a2                	ld	s3,8(sp)
  4e:	6145                	addi	sp,sp,48
  50:	8082                	ret
  52:	8082                	ret

0000000000000054 <find>:

void
find(char *path, char *fileName)
{
  54:	d8010113          	addi	sp,sp,-640
  58:	26113c23          	sd	ra,632(sp)
  5c:	26813823          	sd	s0,624(sp)
  60:	26913423          	sd	s1,616(sp)
  64:	27213023          	sd	s2,608(sp)
  68:	25313c23          	sd	s3,600(sp)
  6c:	25413823          	sd	s4,592(sp)
  70:	25513423          	sd	s5,584(sp)
  74:	25613023          	sd	s6,576(sp)
  78:	23713c23          	sd	s7,568(sp)
  7c:	0500                	addi	s0,sp,640
  7e:	892a                	mv	s2,a0
  80:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0) {
  82:	4581                	li	a1,0
  84:	00000097          	auipc	ra,0x0
  88:	4ba080e7          	jalr	1210(ra) # 53e <open>
  8c:	84aa                	mv	s1,a0
  8e:	06054663          	bltz	a0,fa <find+0xa6>
    fprintf(2, "find: cannot open %s\n", path);
    close(fd);
    return;
  }

  if(fstat(fd, &st) < 0) {
  92:	d8840593          	addi	a1,s0,-632
  96:	00000097          	auipc	ra,0x0
  9a:	4c0080e7          	jalr	1216(ra) # 556 <fstat>
  9e:	06054e63          	bltz	a0,11a <find+0xc6>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type) {
  a2:	d9041783          	lh	a5,-624(s0)
  a6:	0007869b          	sext.w	a3,a5
  aa:	4705                	li	a4,1
  ac:	08e68763          	beq	a3,a4,13a <find+0xe6>
  b0:	37f9                	addiw	a5,a5,-2
  b2:	17c2                	slli	a5,a5,0x30
  b4:	93c1                	srli	a5,a5,0x30
  b6:	00f76863          	bltu	a4,a5,c6 <find+0x72>
    case T_DEVICE:
    case T_FILE:
      match(path, fileName);
  ba:	85ce                	mv	a1,s3
  bc:	854a                	mv	a0,s2
  be:	00000097          	auipc	ra,0x0
  c2:	f42080e7          	jalr	-190(ra) # 0 <match>
        }
        find(buf, fileName);
      }
      break;
  }
  close(fd);
  c6:	8526                	mv	a0,s1
  c8:	00000097          	auipc	ra,0x0
  cc:	45e080e7          	jalr	1118(ra) # 526 <close>
  d0:	27813083          	ld	ra,632(sp)
  d4:	27013403          	ld	s0,624(sp)
  d8:	26813483          	ld	s1,616(sp)
  dc:	26013903          	ld	s2,608(sp)
  e0:	25813983          	ld	s3,600(sp)
  e4:	25013a03          	ld	s4,592(sp)
  e8:	24813a83          	ld	s5,584(sp)
  ec:	24013b03          	ld	s6,576(sp)
  f0:	23813b83          	ld	s7,568(sp)
  f4:	28010113          	addi	sp,sp,640
  f8:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
  fa:	864a                	mv	a2,s2
  fc:	00001597          	auipc	a1,0x1
 100:	92458593          	addi	a1,a1,-1756 # a20 <malloc+0xf0>
 104:	4509                	li	a0,2
 106:	00000097          	auipc	ra,0x0
 10a:	744080e7          	jalr	1860(ra) # 84a <fprintf>
    close(fd);
 10e:	8526                	mv	a0,s1
 110:	00000097          	auipc	ra,0x0
 114:	416080e7          	jalr	1046(ra) # 526 <close>
    return;
 118:	bf65                	j	d0 <find+0x7c>
    fprintf(2, "find: cannot stat %s\n", path);
 11a:	864a                	mv	a2,s2
 11c:	00001597          	auipc	a1,0x1
 120:	91c58593          	addi	a1,a1,-1764 # a38 <malloc+0x108>
 124:	4509                	li	a0,2
 126:	00000097          	auipc	ra,0x0
 12a:	724080e7          	jalr	1828(ra) # 84a <fprintf>
    close(fd);
 12e:	8526                	mv	a0,s1
 130:	00000097          	auipc	ra,0x0
 134:	3f6080e7          	jalr	1014(ra) # 526 <close>
    return;
 138:	bf61                	j	d0 <find+0x7c>
      if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 13a:	854a                	mv	a0,s2
 13c:	00000097          	auipc	ra,0x0
 140:	19e080e7          	jalr	414(ra) # 2da <strlen>
 144:	2541                	addiw	a0,a0,16
 146:	20000793          	li	a5,512
 14a:	00a7fb63          	bgeu	a5,a0,160 <find+0x10c>
        printf("ls: path too long\n");
 14e:	00001517          	auipc	a0,0x1
 152:	90250513          	addi	a0,a0,-1790 # a50 <malloc+0x120>
 156:	00000097          	auipc	ra,0x0
 15a:	722080e7          	jalr	1826(ra) # 878 <printf>
        break;
 15e:	b7a5                	j	c6 <find+0x72>
      strcpy(buf, path);
 160:	85ca                	mv	a1,s2
 162:	db040513          	addi	a0,s0,-592
 166:	00000097          	auipc	ra,0x0
 16a:	12c080e7          	jalr	300(ra) # 292 <strcpy>
      p = buf + strlen(buf);
 16e:	db040513          	addi	a0,s0,-592
 172:	00000097          	auipc	ra,0x0
 176:	168080e7          	jalr	360(ra) # 2da <strlen>
 17a:	1502                	slli	a0,a0,0x20
 17c:	9101                	srli	a0,a0,0x20
 17e:	db040793          	addi	a5,s0,-592
 182:	00a78933          	add	s2,a5,a0
      *p++ = '/';
 186:	00190b13          	addi	s6,s2,1
 18a:	02f00793          	li	a5,47
 18e:	00f90023          	sb	a5,0(s2)
        if(de.name[0] == '.' && de.name[1] == '\0')
 192:	02e00a93          	li	s5,46
        if(de.name[0] == '.' && de.name[1] == '.')
 196:	6a0d                	lui	s4,0x3
 198:	e2ea0a13          	addi	s4,s4,-466 # 2e2e <base+0x1e1e>
          printf("ls: cannot stat %s\n", buf);
 19c:	00001b97          	auipc	s7,0x1
 1a0:	8ccb8b93          	addi	s7,s7,-1844 # a68 <malloc+0x138>
      while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 1a4:	4641                	li	a2,16
 1a6:	da040593          	addi	a1,s0,-608
 1aa:	8526                	mv	a0,s1
 1ac:	00000097          	auipc	ra,0x0
 1b0:	36a080e7          	jalr	874(ra) # 516 <read>
 1b4:	47c1                	li	a5,16
 1b6:	f0f518e3          	bne	a0,a5,c6 <find+0x72>
        if(de.inum == 0)
 1ba:	da045783          	lhu	a5,-608(s0)
 1be:	d3fd                	beqz	a5,1a4 <find+0x150>
        if(de.name[0] == '.' && de.name[1] == '\0')
 1c0:	da245783          	lhu	a5,-606(s0)
 1c4:	0007871b          	sext.w	a4,a5
 1c8:	fd570ee3          	beq	a4,s5,1a4 <find+0x150>
        if(de.name[0] == '.' && de.name[1] == '.')
 1cc:	fd470ce3          	beq	a4,s4,1a4 <find+0x150>
        memmove(p, de.name, DIRSIZ);
 1d0:	4639                	li	a2,14
 1d2:	da240593          	addi	a1,s0,-606
 1d6:	855a                	mv	a0,s6
 1d8:	00000097          	auipc	ra,0x0
 1dc:	274080e7          	jalr	628(ra) # 44c <memmove>
        p[DIRSIZ] = 0;
 1e0:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0) {
 1e4:	d8840593          	addi	a1,s0,-632
 1e8:	db040513          	addi	a0,s0,-592
 1ec:	00000097          	auipc	ra,0x0
 1f0:	1d2080e7          	jalr	466(ra) # 3be <stat>
 1f4:	00054a63          	bltz	a0,208 <find+0x1b4>
        find(buf, fileName);
 1f8:	85ce                	mv	a1,s3
 1fa:	db040513          	addi	a0,s0,-592
 1fe:	00000097          	auipc	ra,0x0
 202:	e56080e7          	jalr	-426(ra) # 54 <find>
 206:	bf79                	j	1a4 <find+0x150>
          printf("ls: cannot stat %s\n", buf);
 208:	db040593          	addi	a1,s0,-592
 20c:	855e                	mv	a0,s7
 20e:	00000097          	auipc	ra,0x0
 212:	66a080e7          	jalr	1642(ra) # 878 <printf>
          continue;
 216:	b779                	j	1a4 <find+0x150>

0000000000000218 <main>:
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  if(argc < 2 || argc > 3)
 220:	ffe5069b          	addiw	a3,a0,-2
 224:	4705                	li	a4,1
 226:	02d76163          	bltu	a4,a3,248 <main+0x30>
 22a:	87ae                	mv	a5,a1
  if(argc == 2)
 22c:	4709                	li	a4,2
 22e:	02e50b63          	beq	a0,a4,264 <main+0x4c>
    find(argv[1], argv[2]);
 232:	698c                	ld	a1,16(a1)
 234:	6788                	ld	a0,8(a5)
 236:	00000097          	auipc	ra,0x0
 23a:	e1e080e7          	jalr	-482(ra) # 54 <find>
  exit(0);
 23e:	4501                	li	a0,0
 240:	00000097          	auipc	ra,0x0
 244:	2be080e7          	jalr	702(ra) # 4fe <exit>
    fprintf(2, "Usage: find [file_path] [file_name]\n");
 248:	00001597          	auipc	a1,0x1
 24c:	83858593          	addi	a1,a1,-1992 # a80 <malloc+0x150>
 250:	4509                	li	a0,2
 252:	00000097          	auipc	ra,0x0
 256:	5f8080e7          	jalr	1528(ra) # 84a <fprintf>
    exit(1);
 25a:	4505                	li	a0,1
 25c:	00000097          	auipc	ra,0x0
 260:	2a2080e7          	jalr	674(ra) # 4fe <exit>
    find(".", argv[1]);
 264:	658c                	ld	a1,8(a1)
 266:	00001517          	auipc	a0,0x1
 26a:	84250513          	addi	a0,a0,-1982 # aa8 <malloc+0x178>
 26e:	00000097          	auipc	ra,0x0
 272:	de6080e7          	jalr	-538(ra) # 54 <find>
 276:	b7e1                	j	23e <main+0x26>

0000000000000278 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 280:	00000097          	auipc	ra,0x0
 284:	f98080e7          	jalr	-104(ra) # 218 <main>
  exit(0);
 288:	4501                	li	a0,0
 28a:	00000097          	auipc	ra,0x0
 28e:	274080e7          	jalr	628(ra) # 4fe <exit>

0000000000000292 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 298:	87aa                	mv	a5,a0
 29a:	0585                	addi	a1,a1,1
 29c:	0785                	addi	a5,a5,1
 29e:	fff5c703          	lbu	a4,-1(a1)
 2a2:	fee78fa3          	sb	a4,-1(a5)
 2a6:	fb75                	bnez	a4,29a <strcpy+0x8>
    ;
  return os;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret

00000000000002ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2b4:	00054783          	lbu	a5,0(a0)
 2b8:	cb91                	beqz	a5,2cc <strcmp+0x1e>
 2ba:	0005c703          	lbu	a4,0(a1)
 2be:	00f71763          	bne	a4,a5,2cc <strcmp+0x1e>
    p++, q++;
 2c2:	0505                	addi	a0,a0,1
 2c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	fbe5                	bnez	a5,2ba <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2cc:	0005c503          	lbu	a0,0(a1)
}
 2d0:	40a7853b          	subw	a0,a5,a0
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <strlen>:

uint
strlen(const char *s)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	cf91                	beqz	a5,300 <strlen+0x26>
 2e6:	0505                	addi	a0,a0,1
 2e8:	87aa                	mv	a5,a0
 2ea:	4685                	li	a3,1
 2ec:	9e89                	subw	a3,a3,a0
 2ee:	00f6853b          	addw	a0,a3,a5
 2f2:	0785                	addi	a5,a5,1
 2f4:	fff7c703          	lbu	a4,-1(a5)
 2f8:	fb7d                	bnez	a4,2ee <strlen+0x14>
    ;
  return n;
}
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
  for(n = 0; s[n]; n++)
 300:	4501                	li	a0,0
 302:	bfe5                	j	2fa <strlen+0x20>

0000000000000304 <memset>:

void*
memset(void *dst, int c, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e422                	sd	s0,8(sp)
 308:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 30a:	ca19                	beqz	a2,320 <memset+0x1c>
 30c:	87aa                	mv	a5,a0
 30e:	1602                	slli	a2,a2,0x20
 310:	9201                	srli	a2,a2,0x20
 312:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 316:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 31a:	0785                	addi	a5,a5,1
 31c:	fee79de3          	bne	a5,a4,316 <memset+0x12>
  }
  return dst;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <strchr>:

char*
strchr(const char *s, char c)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 32c:	00054783          	lbu	a5,0(a0)
 330:	cb99                	beqz	a5,346 <strchr+0x20>
    if(*s == c)
 332:	00f58763          	beq	a1,a5,340 <strchr+0x1a>
  for(; *s; s++)
 336:	0505                	addi	a0,a0,1
 338:	00054783          	lbu	a5,0(a0)
 33c:	fbfd                	bnez	a5,332 <strchr+0xc>
      return (char*)s;
  return 0;
 33e:	4501                	li	a0,0
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  return 0;
 346:	4501                	li	a0,0
 348:	bfe5                	j	340 <strchr+0x1a>

000000000000034a <gets>:

char*
gets(char *buf, int max)
{
 34a:	711d                	addi	sp,sp,-96
 34c:	ec86                	sd	ra,88(sp)
 34e:	e8a2                	sd	s0,80(sp)
 350:	e4a6                	sd	s1,72(sp)
 352:	e0ca                	sd	s2,64(sp)
 354:	fc4e                	sd	s3,56(sp)
 356:	f852                	sd	s4,48(sp)
 358:	f456                	sd	s5,40(sp)
 35a:	f05a                	sd	s6,32(sp)
 35c:	ec5e                	sd	s7,24(sp)
 35e:	1080                	addi	s0,sp,96
 360:	8baa                	mv	s7,a0
 362:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 364:	892a                	mv	s2,a0
 366:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 368:	4aa9                	li	s5,10
 36a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 36c:	89a6                	mv	s3,s1
 36e:	2485                	addiw	s1,s1,1
 370:	0344d863          	bge	s1,s4,3a0 <gets+0x56>
    cc = read(0, &c, 1);
 374:	4605                	li	a2,1
 376:	faf40593          	addi	a1,s0,-81
 37a:	4501                	li	a0,0
 37c:	00000097          	auipc	ra,0x0
 380:	19a080e7          	jalr	410(ra) # 516 <read>
    if(cc < 1)
 384:	00a05e63          	blez	a0,3a0 <gets+0x56>
    buf[i++] = c;
 388:	faf44783          	lbu	a5,-81(s0)
 38c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 390:	01578763          	beq	a5,s5,39e <gets+0x54>
 394:	0905                	addi	s2,s2,1
 396:	fd679be3          	bne	a5,s6,36c <gets+0x22>
  for(i=0; i+1 < max; ){
 39a:	89a6                	mv	s3,s1
 39c:	a011                	j	3a0 <gets+0x56>
 39e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3a0:	99de                	add	s3,s3,s7
 3a2:	00098023          	sb	zero,0(s3)
  return buf;
}
 3a6:	855e                	mv	a0,s7
 3a8:	60e6                	ld	ra,88(sp)
 3aa:	6446                	ld	s0,80(sp)
 3ac:	64a6                	ld	s1,72(sp)
 3ae:	6906                	ld	s2,64(sp)
 3b0:	79e2                	ld	s3,56(sp)
 3b2:	7a42                	ld	s4,48(sp)
 3b4:	7aa2                	ld	s5,40(sp)
 3b6:	7b02                	ld	s6,32(sp)
 3b8:	6be2                	ld	s7,24(sp)
 3ba:	6125                	addi	sp,sp,96
 3bc:	8082                	ret

00000000000003be <stat>:

int
stat(const char *n, struct stat *st)
{
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	e426                	sd	s1,8(sp)
 3c6:	e04a                	sd	s2,0(sp)
 3c8:	1000                	addi	s0,sp,32
 3ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3cc:	4581                	li	a1,0
 3ce:	00000097          	auipc	ra,0x0
 3d2:	170080e7          	jalr	368(ra) # 53e <open>
  if(fd < 0)
 3d6:	02054563          	bltz	a0,400 <stat+0x42>
 3da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3dc:	85ca                	mv	a1,s2
 3de:	00000097          	auipc	ra,0x0
 3e2:	178080e7          	jalr	376(ra) # 556 <fstat>
 3e6:	892a                	mv	s2,a0
  close(fd);
 3e8:	8526                	mv	a0,s1
 3ea:	00000097          	auipc	ra,0x0
 3ee:	13c080e7          	jalr	316(ra) # 526 <close>
  return r;
}
 3f2:	854a                	mv	a0,s2
 3f4:	60e2                	ld	ra,24(sp)
 3f6:	6442                	ld	s0,16(sp)
 3f8:	64a2                	ld	s1,8(sp)
 3fa:	6902                	ld	s2,0(sp)
 3fc:	6105                	addi	sp,sp,32
 3fe:	8082                	ret
    return -1;
 400:	597d                	li	s2,-1
 402:	bfc5                	j	3f2 <stat+0x34>

0000000000000404 <atoi>:

int
atoi(const char *s)
{
 404:	1141                	addi	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40a:	00054683          	lbu	a3,0(a0)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	4625                	li	a2,9
 418:	02f66863          	bltu	a2,a5,448 <atoi+0x44>
 41c:	872a                	mv	a4,a0
  n = 0;
 41e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 420:	0705                	addi	a4,a4,1
 422:	0025179b          	slliw	a5,a0,0x2
 426:	9fa9                	addw	a5,a5,a0
 428:	0017979b          	slliw	a5,a5,0x1
 42c:	9fb5                	addw	a5,a5,a3
 42e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 432:	00074683          	lbu	a3,0(a4)
 436:	fd06879b          	addiw	a5,a3,-48
 43a:	0ff7f793          	zext.b	a5,a5
 43e:	fef671e3          	bgeu	a2,a5,420 <atoi+0x1c>
  return n;
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  n = 0;
 448:	4501                	li	a0,0
 44a:	bfe5                	j	442 <atoi+0x3e>

000000000000044c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e422                	sd	s0,8(sp)
 450:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 452:	02b57463          	bgeu	a0,a1,47a <memmove+0x2e>
    while(n-- > 0)
 456:	00c05f63          	blez	a2,474 <memmove+0x28>
 45a:	1602                	slli	a2,a2,0x20
 45c:	9201                	srli	a2,a2,0x20
 45e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 462:	872a                	mv	a4,a0
      *dst++ = *src++;
 464:	0585                	addi	a1,a1,1
 466:	0705                	addi	a4,a4,1
 468:	fff5c683          	lbu	a3,-1(a1)
 46c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 470:	fee79ae3          	bne	a5,a4,464 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
    dst += n;
 47a:	00c50733          	add	a4,a0,a2
    src += n;
 47e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 480:	fec05ae3          	blez	a2,474 <memmove+0x28>
 484:	fff6079b          	addiw	a5,a2,-1
 488:	1782                	slli	a5,a5,0x20
 48a:	9381                	srli	a5,a5,0x20
 48c:	fff7c793          	not	a5,a5
 490:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 492:	15fd                	addi	a1,a1,-1
 494:	177d                	addi	a4,a4,-1
 496:	0005c683          	lbu	a3,0(a1)
 49a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 49e:	fee79ae3          	bne	a5,a4,492 <memmove+0x46>
 4a2:	bfc9                	j	474 <memmove+0x28>

00000000000004a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e422                	sd	s0,8(sp)
 4a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4aa:	ca05                	beqz	a2,4da <memcmp+0x36>
 4ac:	fff6069b          	addiw	a3,a2,-1
 4b0:	1682                	slli	a3,a3,0x20
 4b2:	9281                	srli	a3,a3,0x20
 4b4:	0685                	addi	a3,a3,1
 4b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	0005c703          	lbu	a4,0(a1)
 4c0:	00e79863          	bne	a5,a4,4d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4c4:	0505                	addi	a0,a0,1
    p2++;
 4c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4c8:	fed518e3          	bne	a0,a3,4b8 <memcmp+0x14>
  }
  return 0;
 4cc:	4501                	li	a0,0
 4ce:	a019                	j	4d4 <memcmp+0x30>
      return *p1 - *p2;
 4d0:	40e7853b          	subw	a0,a5,a4
}
 4d4:	6422                	ld	s0,8(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret
  return 0;
 4da:	4501                	li	a0,0
 4dc:	bfe5                	j	4d4 <memcmp+0x30>

00000000000004de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e6:	00000097          	auipc	ra,0x0
 4ea:	f66080e7          	jalr	-154(ra) # 44c <memmove>
}
 4ee:	60a2                	ld	ra,8(sp)
 4f0:	6402                	ld	s0,0(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret

00000000000004f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f6:	4885                	li	a7,1
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fe:	4889                	li	a7,2
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <wait>:
.global wait
wait:
 li a7, SYS_wait
 506:	488d                	li	a7,3
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 50e:	4891                	li	a7,4
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <read>:
.global read
read:
 li a7, SYS_read
 516:	4895                	li	a7,5
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <write>:
.global write
write:
 li a7, SYS_write
 51e:	48c1                	li	a7,16
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <close>:
.global close
close:
 li a7, SYS_close
 526:	48d5                	li	a7,21
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <kill>:
.global kill
kill:
 li a7, SYS_kill
 52e:	4899                	li	a7,6
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <exec>:
.global exec
exec:
 li a7, SYS_exec
 536:	489d                	li	a7,7
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <open>:
.global open
open:
 li a7, SYS_open
 53e:	48bd                	li	a7,15
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 546:	48c5                	li	a7,17
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 54e:	48c9                	li	a7,18
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 556:	48a1                	li	a7,8
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <link>:
.global link
link:
 li a7, SYS_link
 55e:	48cd                	li	a7,19
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 566:	48d1                	li	a7,20
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 56e:	48a5                	li	a7,9
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <dup>:
.global dup
dup:
 li a7, SYS_dup
 576:	48a9                	li	a7,10
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 57e:	48ad                	li	a7,11
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 586:	48b1                	li	a7,12
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 58e:	48b5                	li	a7,13
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 596:	48b9                	li	a7,14
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 59e:	1101                	addi	sp,sp,-32
 5a0:	ec06                	sd	ra,24(sp)
 5a2:	e822                	sd	s0,16(sp)
 5a4:	1000                	addi	s0,sp,32
 5a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5aa:	4605                	li	a2,1
 5ac:	fef40593          	addi	a1,s0,-17
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f6e080e7          	jalr	-146(ra) # 51e <write>
}
 5b8:	60e2                	ld	ra,24(sp)
 5ba:	6442                	ld	s0,16(sp)
 5bc:	6105                	addi	sp,sp,32
 5be:	8082                	ret

00000000000005c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c0:	7139                	addi	sp,sp,-64
 5c2:	fc06                	sd	ra,56(sp)
 5c4:	f822                	sd	s0,48(sp)
 5c6:	f426                	sd	s1,40(sp)
 5c8:	f04a                	sd	s2,32(sp)
 5ca:	ec4e                	sd	s3,24(sp)
 5cc:	0080                	addi	s0,sp,64
 5ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d0:	c299                	beqz	a3,5d6 <printint+0x16>
 5d2:	0805c963          	bltz	a1,664 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d6:	2581                	sext.w	a1,a1
  neg = 0;
 5d8:	4881                	li	a7,0
 5da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e0:	2601                	sext.w	a2,a2
 5e2:	00000517          	auipc	a0,0x0
 5e6:	52e50513          	addi	a0,a0,1326 # b10 <digits>
 5ea:	883a                	mv	a6,a4
 5ec:	2705                	addiw	a4,a4,1
 5ee:	02c5f7bb          	remuw	a5,a1,a2
 5f2:	1782                	slli	a5,a5,0x20
 5f4:	9381                	srli	a5,a5,0x20
 5f6:	97aa                	add	a5,a5,a0
 5f8:	0007c783          	lbu	a5,0(a5)
 5fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 600:	0005879b          	sext.w	a5,a1
 604:	02c5d5bb          	divuw	a1,a1,a2
 608:	0685                	addi	a3,a3,1
 60a:	fec7f0e3          	bgeu	a5,a2,5ea <printint+0x2a>
  if(neg)
 60e:	00088c63          	beqz	a7,626 <printint+0x66>
    buf[i++] = '-';
 612:	fd070793          	addi	a5,a4,-48
 616:	00878733          	add	a4,a5,s0
 61a:	02d00793          	li	a5,45
 61e:	fef70823          	sb	a5,-16(a4)
 622:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 626:	02e05863          	blez	a4,656 <printint+0x96>
 62a:	fc040793          	addi	a5,s0,-64
 62e:	00e78933          	add	s2,a5,a4
 632:	fff78993          	addi	s3,a5,-1
 636:	99ba                	add	s3,s3,a4
 638:	377d                	addiw	a4,a4,-1
 63a:	1702                	slli	a4,a4,0x20
 63c:	9301                	srli	a4,a4,0x20
 63e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 642:	fff94583          	lbu	a1,-1(s2)
 646:	8526                	mv	a0,s1
 648:	00000097          	auipc	ra,0x0
 64c:	f56080e7          	jalr	-170(ra) # 59e <putc>
  while(--i >= 0)
 650:	197d                	addi	s2,s2,-1
 652:	ff3918e3          	bne	s2,s3,642 <printint+0x82>
}
 656:	70e2                	ld	ra,56(sp)
 658:	7442                	ld	s0,48(sp)
 65a:	74a2                	ld	s1,40(sp)
 65c:	7902                	ld	s2,32(sp)
 65e:	69e2                	ld	s3,24(sp)
 660:	6121                	addi	sp,sp,64
 662:	8082                	ret
    x = -xx;
 664:	40b005bb          	negw	a1,a1
    neg = 1;
 668:	4885                	li	a7,1
    x = -xx;
 66a:	bf85                	j	5da <printint+0x1a>

000000000000066c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66c:	7119                	addi	sp,sp,-128
 66e:	fc86                	sd	ra,120(sp)
 670:	f8a2                	sd	s0,112(sp)
 672:	f4a6                	sd	s1,104(sp)
 674:	f0ca                	sd	s2,96(sp)
 676:	ecce                	sd	s3,88(sp)
 678:	e8d2                	sd	s4,80(sp)
 67a:	e4d6                	sd	s5,72(sp)
 67c:	e0da                	sd	s6,64(sp)
 67e:	fc5e                	sd	s7,56(sp)
 680:	f862                	sd	s8,48(sp)
 682:	f466                	sd	s9,40(sp)
 684:	f06a                	sd	s10,32(sp)
 686:	ec6e                	sd	s11,24(sp)
 688:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 68a:	0005c903          	lbu	s2,0(a1)
 68e:	18090f63          	beqz	s2,82c <vprintf+0x1c0>
 692:	8aaa                	mv	s5,a0
 694:	8b32                	mv	s6,a2
 696:	00158493          	addi	s1,a1,1
  state = 0;
 69a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69c:	02500a13          	li	s4,37
 6a0:	4c55                	li	s8,21
 6a2:	00000c97          	auipc	s9,0x0
 6a6:	416c8c93          	addi	s9,s9,1046 # ab8 <malloc+0x188>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6aa:	02800d93          	li	s11,40
  putc(fd, 'x');
 6ae:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b0:	00000b97          	auipc	s7,0x0
 6b4:	460b8b93          	addi	s7,s7,1120 # b10 <digits>
 6b8:	a839                	j	6d6 <vprintf+0x6a>
        putc(fd, c);
 6ba:	85ca                	mv	a1,s2
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	ee0080e7          	jalr	-288(ra) # 59e <putc>
 6c6:	a019                	j	6cc <vprintf+0x60>
    } else if(state == '%'){
 6c8:	01498d63          	beq	s3,s4,6e2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6cc:	0485                	addi	s1,s1,1
 6ce:	fff4c903          	lbu	s2,-1(s1)
 6d2:	14090d63          	beqz	s2,82c <vprintf+0x1c0>
    if(state == 0){
 6d6:	fe0999e3          	bnez	s3,6c8 <vprintf+0x5c>
      if(c == '%'){
 6da:	ff4910e3          	bne	s2,s4,6ba <vprintf+0x4e>
        state = '%';
 6de:	89d2                	mv	s3,s4
 6e0:	b7f5                	j	6cc <vprintf+0x60>
      if(c == 'd'){
 6e2:	11490c63          	beq	s2,s4,7fa <vprintf+0x18e>
 6e6:	f9d9079b          	addiw	a5,s2,-99
 6ea:	0ff7f793          	zext.b	a5,a5
 6ee:	10fc6e63          	bltu	s8,a5,80a <vprintf+0x19e>
 6f2:	f9d9079b          	addiw	a5,s2,-99
 6f6:	0ff7f713          	zext.b	a4,a5
 6fa:	10ec6863          	bltu	s8,a4,80a <vprintf+0x19e>
 6fe:	00271793          	slli	a5,a4,0x2
 702:	97e6                	add	a5,a5,s9
 704:	439c                	lw	a5,0(a5)
 706:	97e6                	add	a5,a5,s9
 708:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 70a:	008b0913          	addi	s2,s6,8
 70e:	4685                	li	a3,1
 710:	4629                	li	a2,10
 712:	000b2583          	lw	a1,0(s6)
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	ea8080e7          	jalr	-344(ra) # 5c0 <printint>
 720:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 722:	4981                	li	s3,0
 724:	b765                	j	6cc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 726:	008b0913          	addi	s2,s6,8
 72a:	4681                	li	a3,0
 72c:	4629                	li	a2,10
 72e:	000b2583          	lw	a1,0(s6)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e8c080e7          	jalr	-372(ra) # 5c0 <printint>
 73c:	8b4a                	mv	s6,s2
      state = 0;
 73e:	4981                	li	s3,0
 740:	b771                	j	6cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 742:	008b0913          	addi	s2,s6,8
 746:	4681                	li	a3,0
 748:	866a                	mv	a2,s10
 74a:	000b2583          	lw	a1,0(s6)
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e70080e7          	jalr	-400(ra) # 5c0 <printint>
 758:	8b4a                	mv	s6,s2
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bf85                	j	6cc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 75e:	008b0793          	addi	a5,s6,8
 762:	f8f43423          	sd	a5,-120(s0)
 766:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 76a:	03000593          	li	a1,48
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	e2e080e7          	jalr	-466(ra) # 59e <putc>
  putc(fd, 'x');
 778:	07800593          	li	a1,120
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e20080e7          	jalr	-480(ra) # 59e <putc>
 786:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 788:	03c9d793          	srli	a5,s3,0x3c
 78c:	97de                	add	a5,a5,s7
 78e:	0007c583          	lbu	a1,0(a5)
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	e0a080e7          	jalr	-502(ra) # 59e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79c:	0992                	slli	s3,s3,0x4
 79e:	397d                	addiw	s2,s2,-1
 7a0:	fe0914e3          	bnez	s2,788 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7a4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b70d                	j	6cc <vprintf+0x60>
        s = va_arg(ap, char*);
 7ac:	008b0913          	addi	s2,s6,8
 7b0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7b4:	02098163          	beqz	s3,7d6 <vprintf+0x16a>
        while(*s != 0){
 7b8:	0009c583          	lbu	a1,0(s3)
 7bc:	c5ad                	beqz	a1,826 <vprintf+0x1ba>
          putc(fd, *s);
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	dde080e7          	jalr	-546(ra) # 59e <putc>
          s++;
 7c8:	0985                	addi	s3,s3,1
        while(*s != 0){
 7ca:	0009c583          	lbu	a1,0(s3)
 7ce:	f9e5                	bnez	a1,7be <vprintf+0x152>
        s = va_arg(ap, char*);
 7d0:	8b4a                	mv	s6,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bde5                	j	6cc <vprintf+0x60>
          s = "(null)";
 7d6:	00000997          	auipc	s3,0x0
 7da:	2da98993          	addi	s3,s3,730 # ab0 <malloc+0x180>
        while(*s != 0){
 7de:	85ee                	mv	a1,s11
 7e0:	bff9                	j	7be <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7e2:	008b0913          	addi	s2,s6,8
 7e6:	000b4583          	lbu	a1,0(s6)
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	db2080e7          	jalr	-590(ra) # 59e <putc>
 7f4:	8b4a                	mv	s6,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bdd1                	j	6cc <vprintf+0x60>
        putc(fd, c);
 7fa:	85d2                	mv	a1,s4
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	da0080e7          	jalr	-608(ra) # 59e <putc>
      state = 0;
 806:	4981                	li	s3,0
 808:	b5d1                	j	6cc <vprintf+0x60>
        putc(fd, '%');
 80a:	85d2                	mv	a1,s4
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	d90080e7          	jalr	-624(ra) # 59e <putc>
        putc(fd, c);
 816:	85ca                	mv	a1,s2
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	d84080e7          	jalr	-636(ra) # 59e <putc>
      state = 0;
 822:	4981                	li	s3,0
 824:	b565                	j	6cc <vprintf+0x60>
        s = va_arg(ap, char*);
 826:	8b4a                	mv	s6,s2
      state = 0;
 828:	4981                	li	s3,0
 82a:	b54d                	j	6cc <vprintf+0x60>
    }
  }
}
 82c:	70e6                	ld	ra,120(sp)
 82e:	7446                	ld	s0,112(sp)
 830:	74a6                	ld	s1,104(sp)
 832:	7906                	ld	s2,96(sp)
 834:	69e6                	ld	s3,88(sp)
 836:	6a46                	ld	s4,80(sp)
 838:	6aa6                	ld	s5,72(sp)
 83a:	6b06                	ld	s6,64(sp)
 83c:	7be2                	ld	s7,56(sp)
 83e:	7c42                	ld	s8,48(sp)
 840:	7ca2                	ld	s9,40(sp)
 842:	7d02                	ld	s10,32(sp)
 844:	6de2                	ld	s11,24(sp)
 846:	6109                	addi	sp,sp,128
 848:	8082                	ret

000000000000084a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84a:	715d                	addi	sp,sp,-80
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	e010                	sd	a2,0(s0)
 854:	e414                	sd	a3,8(s0)
 856:	e818                	sd	a4,16(s0)
 858:	ec1c                	sd	a5,24(s0)
 85a:	03043023          	sd	a6,32(s0)
 85e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 862:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 866:	8622                	mv	a2,s0
 868:	00000097          	auipc	ra,0x0
 86c:	e04080e7          	jalr	-508(ra) # 66c <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6161                	addi	sp,sp,80
 876:	8082                	ret

0000000000000878 <printf>:

void
printf(const char *fmt, ...)
{
 878:	711d                	addi	sp,sp,-96
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	addi	s0,sp,32
 880:	e40c                	sd	a1,8(s0)
 882:	e810                	sd	a2,16(s0)
 884:	ec14                	sd	a3,24(s0)
 886:	f018                	sd	a4,32(s0)
 888:	f41c                	sd	a5,40(s0)
 88a:	03043823          	sd	a6,48(s0)
 88e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 892:	00840613          	addi	a2,s0,8
 896:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 89a:	85aa                	mv	a1,a0
 89c:	4505                	li	a0,1
 89e:	00000097          	auipc	ra,0x0
 8a2:	dce080e7          	jalr	-562(ra) # 66c <vprintf>
}
 8a6:	60e2                	ld	ra,24(sp)
 8a8:	6442                	ld	s0,16(sp)
 8aa:	6125                	addi	sp,sp,96
 8ac:	8082                	ret

00000000000008ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ae:	1141                	addi	sp,sp,-16
 8b0:	e422                	sd	s0,8(sp)
 8b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b8:	00000797          	auipc	a5,0x0
 8bc:	7487b783          	ld	a5,1864(a5) # 1000 <freep>
 8c0:	a02d                	j	8ea <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c2:	4618                	lw	a4,8(a2)
 8c4:	9f2d                	addw	a4,a4,a1
 8c6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ca:	6398                	ld	a4,0(a5)
 8cc:	6310                	ld	a2,0(a4)
 8ce:	a83d                	j	90c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d0:	ff852703          	lw	a4,-8(a0)
 8d4:	9f31                	addw	a4,a4,a2
 8d6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d8:	ff053683          	ld	a3,-16(a0)
 8dc:	a091                	j	920 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	6398                	ld	a4,0(a5)
 8e0:	00e7e463          	bltu	a5,a4,8e8 <free+0x3a>
 8e4:	00e6ea63          	bltu	a3,a4,8f8 <free+0x4a>
{
 8e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ea:	fed7fae3          	bgeu	a5,a3,8de <free+0x30>
 8ee:	6398                	ld	a4,0(a5)
 8f0:	00e6e463          	bltu	a3,a4,8f8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f4:	fee7eae3          	bltu	a5,a4,8e8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8f8:	ff852583          	lw	a1,-8(a0)
 8fc:	6390                	ld	a2,0(a5)
 8fe:	02059813          	slli	a6,a1,0x20
 902:	01c85713          	srli	a4,a6,0x1c
 906:	9736                	add	a4,a4,a3
 908:	fae60de3          	beq	a2,a4,8c2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 90c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 910:	4790                	lw	a2,8(a5)
 912:	02061593          	slli	a1,a2,0x20
 916:	01c5d713          	srli	a4,a1,0x1c
 91a:	973e                	add	a4,a4,a5
 91c:	fae68ae3          	beq	a3,a4,8d0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 920:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 922:	00000717          	auipc	a4,0x0
 926:	6cf73f23          	sd	a5,1758(a4) # 1000 <freep>
}
 92a:	6422                	ld	s0,8(sp)
 92c:	0141                	addi	sp,sp,16
 92e:	8082                	ret

0000000000000930 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 930:	7139                	addi	sp,sp,-64
 932:	fc06                	sd	ra,56(sp)
 934:	f822                	sd	s0,48(sp)
 936:	f426                	sd	s1,40(sp)
 938:	f04a                	sd	s2,32(sp)
 93a:	ec4e                	sd	s3,24(sp)
 93c:	e852                	sd	s4,16(sp)
 93e:	e456                	sd	s5,8(sp)
 940:	e05a                	sd	s6,0(sp)
 942:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 944:	02051493          	slli	s1,a0,0x20
 948:	9081                	srli	s1,s1,0x20
 94a:	04bd                	addi	s1,s1,15
 94c:	8091                	srli	s1,s1,0x4
 94e:	0014899b          	addiw	s3,s1,1
 952:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 954:	00000517          	auipc	a0,0x0
 958:	6ac53503          	ld	a0,1708(a0) # 1000 <freep>
 95c:	c515                	beqz	a0,988 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 960:	4798                	lw	a4,8(a5)
 962:	02977f63          	bgeu	a4,s1,9a0 <malloc+0x70>
 966:	8a4e                	mv	s4,s3
 968:	0009871b          	sext.w	a4,s3
 96c:	6685                	lui	a3,0x1
 96e:	00d77363          	bgeu	a4,a3,974 <malloc+0x44>
 972:	6a05                	lui	s4,0x1
 974:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 978:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 97c:	00000917          	auipc	s2,0x0
 980:	68490913          	addi	s2,s2,1668 # 1000 <freep>
  if(p == (char*)-1)
 984:	5afd                	li	s5,-1
 986:	a895                	j	9fa <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 988:	00000797          	auipc	a5,0x0
 98c:	68878793          	addi	a5,a5,1672 # 1010 <base>
 990:	00000717          	auipc	a4,0x0
 994:	66f73823          	sd	a5,1648(a4) # 1000 <freep>
 998:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 99e:	b7e1                	j	966 <malloc+0x36>
      if(p->s.size == nunits)
 9a0:	02e48c63          	beq	s1,a4,9d8 <malloc+0xa8>
        p->s.size -= nunits;
 9a4:	4137073b          	subw	a4,a4,s3
 9a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9aa:	02071693          	slli	a3,a4,0x20
 9ae:	01c6d713          	srli	a4,a3,0x1c
 9b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b8:	00000717          	auipc	a4,0x0
 9bc:	64a73423          	sd	a0,1608(a4) # 1000 <freep>
      return (void*)(p + 1);
 9c0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9c4:	70e2                	ld	ra,56(sp)
 9c6:	7442                	ld	s0,48(sp)
 9c8:	74a2                	ld	s1,40(sp)
 9ca:	7902                	ld	s2,32(sp)
 9cc:	69e2                	ld	s3,24(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
 9d4:	6121                	addi	sp,sp,64
 9d6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9d8:	6398                	ld	a4,0(a5)
 9da:	e118                	sd	a4,0(a0)
 9dc:	bff1                	j	9b8 <malloc+0x88>
  hp->s.size = nu;
 9de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e2:	0541                	addi	a0,a0,16
 9e4:	00000097          	auipc	ra,0x0
 9e8:	eca080e7          	jalr	-310(ra) # 8ae <free>
  return freep;
 9ec:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f0:	d971                	beqz	a0,9c4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f4:	4798                	lw	a4,8(a5)
 9f6:	fa9775e3          	bgeu	a4,s1,9a0 <malloc+0x70>
    if(p == freep)
 9fa:	00093703          	ld	a4,0(s2)
 9fe:	853e                	mv	a0,a5
 a00:	fef719e3          	bne	a4,a5,9f2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a04:	8552                	mv	a0,s4
 a06:	00000097          	auipc	ra,0x0
 a0a:	b80080e7          	jalr	-1152(ra) # 586 <sbrk>
  if(p == (char*)-1)
 a0e:	fd5518e3          	bne	a0,s5,9de <malloc+0xae>
        return 0;
 a12:	4501                	li	a0,0
 a14:	bf45                	j	9c4 <malloc+0x94>
