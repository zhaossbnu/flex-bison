# flex-bison
这是利用flex和bison写的一个C--语言的编译器，可以进行词法分析、语法分析、语义分析以及中间代码生成。  
环境要求：  
  GCC Version: 4.7.1  
  GNU Flex Version: 2.5.37  
  GNU Bison Version: 2.7  
  
运行命令：  
  flex lab4.l  
  bison -d lab4.y  
  gcc lab4.tab.c lab41.c  
  ./a.out test.c  
