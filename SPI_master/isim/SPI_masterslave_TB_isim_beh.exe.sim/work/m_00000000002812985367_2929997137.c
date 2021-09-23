/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/Dropbox/Graduation Research/52 VHDL blocks/at_modules/counters/clkdivcounter_v1.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};



static void Always_47_0(char *t0)
{
    char t16[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    int t13;
    char *t14;
    char *t15;
    char *t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;
    char *t26;

LAB0:    t1 = (t0 + 3896U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(47, ng0);
    t2 = (t0 + 4216);
    *((int *)t2) = 1;
    t3 = (t0 + 3928);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(47, ng0);

LAB5:    xsi_set_current_line(48, ng0);
    t4 = (t0 + 1456U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(53, ng0);

LAB10:    xsi_set_current_line(54, ng0);
    t2 = (t0 + 2976);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);

LAB11:    t5 = (t0 + 472);
    t11 = *((char **)t5);
    t13 = xsi_vlog_unsigned_case_compare(t4, 2, t11, 32);
    if (t13 == 1)
        goto LAB12;

LAB13:    t2 = (t0 + 608);
    t3 = *((char **)t2);
    t13 = xsi_vlog_unsigned_case_compare(t4, 2, t3, 32);
    if (t13 == 1)
        goto LAB14;

LAB15:    t2 = (t0 + 744);
    t3 = *((char **)t2);
    t13 = xsi_vlog_unsigned_case_compare(t4, 2, t3, 32);
    if (t13 == 1)
        goto LAB16;

LAB17:
LAB19:
LAB18:    xsi_set_current_line(98, ng0);

LAB58:    xsi_set_current_line(99, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2496);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(100, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2656);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(101, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2816);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(102, ng0);
    t2 = (t0 + 472);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);

LAB20:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(48, ng0);

LAB9:    xsi_set_current_line(49, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2496);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    xsi_set_current_line(50, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2656);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(51, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2816);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(52, ng0);
    t2 = (t0 + 472);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    goto LAB8;

LAB12:    xsi_set_current_line(55, ng0);

LAB21:    xsi_set_current_line(56, ng0);
    t5 = ((char*)((ng1)));
    t12 = (t0 + 2496);
    xsi_vlogvar_wait_assign_value(t12, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(57, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2656);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2816);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(59, ng0);
    t2 = (t0 + 1616U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB22;

LAB23:
LAB24:    goto LAB20;

LAB14:    xsi_set_current_line(64, ng0);

LAB26:    xsi_set_current_line(65, ng0);
    t2 = ((char*)((ng2)));
    t5 = (t0 + 2496);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(66, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2816);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(67, ng0);
    t2 = (t0 + 1616U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB27;

LAB28:    xsi_set_current_line(75, ng0);

LAB41:    xsi_set_current_line(76, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2656);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(77, ng0);
    t2 = (t0 + 472);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);

LAB29:    goto LAB20;

LAB16:    xsi_set_current_line(81, ng0);

LAB42:    xsi_set_current_line(82, ng0);
    t2 = ((char*)((ng1)));
    t5 = (t0 + 2496);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(83, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2656);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(84, ng0);
    t2 = (t0 + 1616U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB43;

LAB44:    xsi_set_current_line(92, ng0);

LAB57:    xsi_set_current_line(93, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2816);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(94, ng0);
    t2 = (t0 + 472);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);

LAB45:    goto LAB20;

LAB22:    xsi_set_current_line(59, ng0);

LAB25:    xsi_set_current_line(60, ng0);
    t5 = (t0 + 608);
    t11 = *((char **)t5);
    t5 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t5, t11, 0, 0, 2, 0LL);
    goto LAB24;

LAB27:    xsi_set_current_line(67, ng0);

LAB30:    xsi_set_current_line(68, ng0);
    t5 = (t0 + 2656);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t14 = (t0 + 1936U);
    t15 = *((char **)t14);
    memset(t16, 0, 8);
    t14 = (t12 + 4);
    if (*((unsigned int *)t14) != 0)
        goto LAB32;

LAB31:    t17 = (t15 + 4);
    if (*((unsigned int *)t17) != 0)
        goto LAB32;

LAB35:    if (*((unsigned int *)t12) < *((unsigned int *)t15))
        goto LAB34;

LAB33:    *((unsigned int *)t16) = 1;

LAB34:    t19 = (t16 + 4);
    t20 = *((unsigned int *)t19);
    t21 = (~(t20));
    t22 = *((unsigned int *)t16);
    t23 = (t22 & t21);
    t24 = (t23 != 0);
    if (t24 > 0)
        goto LAB36;

LAB37:    xsi_set_current_line(71, ng0);

LAB40:    xsi_set_current_line(72, ng0);
    t2 = (t0 + 2656);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t11 = ((char*)((ng2)));
    memset(t16, 0, 8);
    xsi_vlog_unsigned_add(t16, 32, t5, 32, t11, 32);
    t12 = (t0 + 2656);
    xsi_vlogvar_wait_assign_value(t12, t16, 0, 0, 32, 0LL);
    xsi_set_current_line(73, ng0);
    t2 = (t0 + 608);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);

LAB38:    goto LAB29;

LAB32:    t18 = (t16 + 4);
    *((unsigned int *)t16) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB34;

LAB36:    xsi_set_current_line(68, ng0);

LAB39:    xsi_set_current_line(69, ng0);
    t25 = ((char*)((ng1)));
    t26 = (t0 + 2656);
    xsi_vlogvar_wait_assign_value(t26, t25, 0, 0, 32, 0LL);
    xsi_set_current_line(70, ng0);
    t2 = (t0 + 744);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    goto LAB38;

LAB43:    xsi_set_current_line(84, ng0);

LAB46:    xsi_set_current_line(85, ng0);
    t5 = (t0 + 2816);
    t11 = (t5 + 56U);
    t12 = *((char **)t11);
    t14 = (t0 + 2096U);
    t15 = *((char **)t14);
    memset(t16, 0, 8);
    t14 = (t12 + 4);
    if (*((unsigned int *)t14) != 0)
        goto LAB48;

LAB47:    t17 = (t15 + 4);
    if (*((unsigned int *)t17) != 0)
        goto LAB48;

LAB51:    if (*((unsigned int *)t12) < *((unsigned int *)t15))
        goto LAB50;

LAB49:    *((unsigned int *)t16) = 1;

LAB50:    t19 = (t16 + 4);
    t20 = *((unsigned int *)t19);
    t21 = (~(t20));
    t22 = *((unsigned int *)t16);
    t23 = (t22 & t21);
    t24 = (t23 != 0);
    if (t24 > 0)
        goto LAB52;

LAB53:    xsi_set_current_line(88, ng0);

LAB56:    xsi_set_current_line(89, ng0);
    t2 = (t0 + 2816);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t11 = ((char*)((ng2)));
    memset(t16, 0, 8);
    xsi_vlog_unsigned_add(t16, 32, t5, 32, t11, 32);
    t12 = (t0 + 2816);
    xsi_vlogvar_wait_assign_value(t12, t16, 0, 0, 32, 0LL);
    xsi_set_current_line(90, ng0);
    t2 = (t0 + 744);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);

LAB54:    goto LAB45;

LAB48:    t18 = (t16 + 4);
    *((unsigned int *)t16) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB50;

LAB52:    xsi_set_current_line(85, ng0);

LAB55:    xsi_set_current_line(86, ng0);
    t25 = ((char*)((ng1)));
    t26 = (t0 + 2816);
    xsi_vlogvar_wait_assign_value(t26, t25, 0, 0, 32, 0LL);
    xsi_set_current_line(87, ng0);
    t2 = (t0 + 608);
    t3 = *((char **)t2);
    t2 = (t0 + 2976);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    goto LAB54;

}


extern void work_m_00000000002812985367_2929997137_init()
{
	static char *pe[] = {(void *)Always_47_0};
	xsi_register_didat("work_m_00000000002812985367_2929997137", "isim/SPI_masterslave_TB_isim_beh.exe.sim/work/m_00000000002812985367_2929997137.didat");
	xsi_register_executes(pe);
}
