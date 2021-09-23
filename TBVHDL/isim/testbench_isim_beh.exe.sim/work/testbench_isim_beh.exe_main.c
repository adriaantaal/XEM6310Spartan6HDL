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

#include "xsi.h"

struct XSI_INFO xsi_info;

char *STD_STANDARD;
char *VL_P_2533777724;
char *IEEE_P_0017514958;
char *IEEE_P_1242562249;
char *IEEE_P_2592010699;
char *SYNOPSYS_P_3308480207;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000004134447467_2073120511_init();
    work_m_00000000002115851973_0014666967_init();
    ieee_p_2592010699_init();
    synopsys_p_3308480207_init();
    ieee_p_0017514958_init();
    ieee_p_1242562249_init();
    vl_p_2533777724_init();
    work_a_1949178628_2372691052_init();


    xsi_register_tops("work_a_1949178628_2372691052");
    xsi_register_tops("work_m_00000000004134447467_2073120511");

    STD_STANDARD = xsi_get_engine_memory("std_standard");
    VL_P_2533777724 = xsi_get_engine_memory("vl_p_2533777724");
    IEEE_P_0017514958 = xsi_get_engine_memory("ieee_p_0017514958");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    SYNOPSYS_P_3308480207 = xsi_get_engine_memory("synopsys_p_3308480207");

    return xsi_run_simulation(argc, argv);

}
