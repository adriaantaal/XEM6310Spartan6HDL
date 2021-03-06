/*
###############################################################
#  Generated by:      Cadence Innovus 16.11-s067_1
#  OS:                Linux x86_64(Host ID linrack4.ee.columbia.edu)
#  Generated on:      Thu Aug 30 11:43:26 2018
#  Design:            syn_spi_slave
#  Command:           saveNetlist spi_slave_phy_sim.v -excludeLeafCell -excludeCellInst {FILL1 FILL2 FILL4 FILL8}
###############################################################
*/
// Generated by Cadence Genus(TM) Synthesis Solution 16.11-s015_1
// Generated on: Aug 23 2018 18:12:00 EDT (Aug 23 2018 22:12:00 UTC)
// Verification Directory fv/spi_slave 
module phy_spi_slave (
	rst, 
	spi_ssel_i, 
	spi_sck_i, 
	spi_mosi_i, 
	spi_miso_o, 
	clk_i, 
	do_valid_o, 
	do_o);
   input rst;
   input spi_ssel_i;
   input spi_sck_i;
   input spi_mosi_i;
   output spi_miso_o;
   input clk_i;
   output do_valid_o;
   output [23:0] do_o;

   // Internal wires
   wire FE_OFN88_n_80;
   wire FE_OFN87_n_88;
   wire FE_OFN92_FE_OFN71_n_87;
   wire FE_OFN84_n_42;
   wire FE_OFN83_preload_miso;
   wire FE_OFN91_sh_reg_1;
   wire FE_OFN89_sh_reg_15;
   wire FE_OFN88_n;
   wire FE_OFN78_n_65;
   wire FE_OFN77_n_65;
   wire FE_OFN76_n_133;
   wire FE_OFN75_n_133;
   wire FE_OFN74_n_103;
   wire FE_OFN73_n_103;
   wire FE_OFN71_n_87;
   wire FE_OFN70_n_85;
   wire FE_OFN69_n_85;
   wire FE_OFN68_spi_miso_o;
   wire FE_OFN67_n_186;
   wire FE_OFN66_n_186;
   wire FE_OFN65_n_186;
   wire FE_OFN64_n_186;
   wire FE_OFN63_n_186;
   wire FE_OFN62_n_186;
   wire FE_OFN61_n_186;
   wire FE_OFN60_n_131;
   wire FE_OFN59_n_131;
   wire FE_OFN58_n_105;
   wire FE_OFN56_n_18;
   wire FE_OFN55_n_10;
   wire FE_OFN54_n_10;
   wire FE_OFN51_di_reg_8;
   wire FE_OFN50_sh_reg_0;
   wire FE_OFN48_sh_reg_3;
   wire FE_OFN47_sh_reg_4;
   wire FE_OFN46_sh_reg_5;
   wire FE_OFN45_sh_reg_6;
   wire FE_OFN44_sh_reg_7;
   wire FE_OFN42_sh_reg_10;
   wire FE_OFN41_sh_reg_12;
   wire FE_OFN40_sh_reg_14;
   wire FE_OFN39_sh_reg_16;
   wire FE_OFN38_sh_reg_17;
   wire FE_OFN37_sh_reg_19;
   wire FE_OFN36_sh_reg_21;
   wire FE_OFN35_sh_reg_22;
   wire FE_OFN34_sh_reg_23;
   wire FE_OFN33_do_o_0;
   wire FE_OFN32_do_o_1;
   wire FE_OFN31_do_o_2;
   wire FE_OFN30_do_o_3;
   wire FE_OFN29_do_o_4;
   wire FE_OFN28_do_o_5;
   wire FE_OFN27_do_o_6;
   wire FE_OFN26_do_o_7;
   wire FE_OFN25_do_o_8;
   wire FE_OFN24_do_o_9;
   wire FE_OFN23_do_o_10;
   wire FE_OFN22_do_o_11;
   wire FE_OFN21_do_o_12;
   wire FE_OFN20_do_o_13;
   wire FE_OFN19_do_o_14;
   wire FE_OFN18_do_o_15;
   wire FE_OFN17_do_o_16;
   wire FE_OFN16_do_o_17;
   wire FE_OFN15_do_o_18;
   wire FE_OFN14_do_o_19;
   wire FE_OFN13_do_o_20;
   wire FE_OFN12_do_o_21;
   wire FE_OFN11_do_o_22;
   wire FE_OFN10_do_o_23;
   wire FE_OFN9_do_o_23;
   wire FE_OFN8_do_valid_o;
   wire FE_OFN7_do_valid_o;
   wire FE_OFN6_do_valid_o;
   wire FE_OFN5_do_valid_o;
   wire FE_OFN4_clk_i;
   wire FE_OFN3_clk_i;
   wire FE_OFN2_spi_sck_i;
   wire FE_OFN1_spi_sck_i;
   wire FE_OFN0_spi_sck_i;
   wire FE_DBTN0_do_valid_o;
   wire [23:0] sh_reg;
   wire [23:0] di_reg;
   wire [4:0] state_reg;
   wire UNCONNECTED;
   wire UNCONNECTED0;
   wire UNCONNECTED1;
   wire UNCONNECTED2;
   wire UNCONNECTED3;
   wire UNCONNECTED4;
   wire UNCONNECTED5;
   wire UNCONNECTED6;
   wire UNCONNECTED7;
   wire UNCONNECTED8;
   wire UNCONNECTED9;
   wire UNCONNECTED10;
   wire UNCONNECTED11;
   wire UNCONNECTED12;
   wire UNCONNECTED13;
   wire UNCONNECTED14;
   wire UNCONNECTED15;
   wire UNCONNECTED16;
   wire UNCONNECTED17;
   wire UNCONNECTED18;
   wire UNCONNECTED19;
   wire UNCONNECTED20;
   wire UNCONNECTED21;
   wire UNCONNECTED22;
   wire UNCONNECTED23;
   wire UNCONNECTED24;
   wire UNCONNECTED25;
   wire UNCONNECTED26;
   wire UNCONNECTED27;
   wire UNCONNECTED28;
   wire UNCONNECTED29;
   wire UNCONNECTED30;
   wire UNCONNECTED31;
   wire UNCONNECTED32;
   wire UNCONNECTED33;
   wire UNCONNECTED34;
   wire UNCONNECTED35;
   wire UNCONNECTED36;
   wire UNCONNECTED37;
   wire UNCONNECTED38;
   wire UNCONNECTED39;
   wire UNCONNECTED40;
   wire UNCONNECTED41;
   wire UNCONNECTED42;
   wire UNCONNECTED43;
   wire UNCONNECTED44;
   wire UNCONNECTED45;
   wire UNCONNECTED46;
   wire UNCONNECTED47;
   wire UNCONNECTED48;
   wire UNCONNECTED49;
   wire UNCONNECTED50;
   wire UNCONNECTED51;
   wire UNCONNECTED52;
   wire UNCONNECTED53;
   wire UNCONNECTED54;
   wire UNCONNECTED55;
   wire UNCONNECTED56;
   wire UNCONNECTED57;
   wire UNCONNECTED58;
   wire UNCONNECTED59;
   wire UNCONNECTED60;
   wire UNCONNECTED61;
   wire UNCONNECTED62;
   wire UNCONNECTED63;
   wire UNCONNECTED64;
   wire UNCONNECTED65;
   wire UNCONNECTED66;
   wire UNCONNECTED67;
   wire UNCONNECTED68;
   wire UNCONNECTED69;
   wire UNCONNECTED70;
   wire UNCONNECTED71;
   wire UNCONNECTED72;
   wire UNCONNECTED73;
   wire UNCONNECTED74;
   wire UNCONNECTED75;
   wire UNCONNECTED76;
   wire UNCONNECTED77;
   wire UNCONNECTED78;
   wire UNCONNECTED79;
   wire UNCONNECTED80;
   wire UNCONNECTED81;
   wire UNCONNECTED82;
   wire UNCONNECTED83;
   wire UNCONNECTED84;
   wire UNCONNECTED85;
   wire do_transfer_reg;
   wire do_valid_A;
   wire do_valid_B;
   wire do_valid_C;
   wire do_valid_D;
   wire n_0;
   wire n_1;
   wire n_2;
   wire n_3;
   wire n_4;
   wire n_5;
   wire n_6;
   wire n_7;
   wire n_8;
   wire n_9;
   wire n_10;
   wire n_11;
   wire n_12;
   wire n_13;
   wire n_14;
   wire n_15;
   wire n_16;
   wire n_17;
   wire n_18;
   wire n_19;
   wire n_20;
   wire n_21;
   wire n_22;
   wire n_23;
   wire n_24;
   wire n_25;
   wire n_26;
   wire n_27;
   wire n_28;
   wire n_29;
   wire n_30;
   wire n_31;
   wire n_32;
   wire n_34;
   wire n_35;
   wire n_36;
   wire n_37;
   wire n_38;
   wire n_39;
   wire n_40;
   wire n_41;
   wire n_42;
   wire n_43;
   wire n_44;
   wire n_45;
   wire n_46;
   wire n_47;
   wire n_48;
   wire n_49;
   wire n_50;
   wire n_51;
   wire n_52;
   wire n_53;
   wire n_54;
   wire n_55;
   wire n_56;
   wire n_57;
   wire n_58;
   wire n_59;
   wire n_60;
   wire n_61;
   wire n_62;
   wire n_63;
   wire n_64;
   wire n_65;
   wire n_66;
   wire n_67;
   wire n_68;
   wire n_69;
   wire n_70;
   wire n_71;
   wire n_72;
   wire n_73;
   wire n_74;
   wire n_75;
   wire n_76;
   wire n_77;
   wire n_78;
   wire n_79;
   wire n_80;
   wire n_81;
   wire n_82;
   wire n_83;
   wire n_84;
   wire n_85;
   wire n_86;
   wire n_87;
   wire n_88;
   wire n_89;
   wire n_90;
   wire n_91;
   wire n_92;
   wire n_93;
   wire n_94;
   wire n_95;
   wire n_96;
   wire n_97;
   wire n_98;
   wire n_99;
   wire n_100;
   wire n_101;
   wire n_102;
   wire n_103;
   wire n_104;
   wire n_105;
   wire n_106;
   wire n_107;
   wire n_108;
   wire n_109;
   wire n_110;
   wire n_111;
   wire n_112;
   wire n_113;
   wire n_114;
   wire n_116;
   wire n_117;
   wire n_118;
   wire n_119;
   wire n_121;
   wire n_122;
   wire n_123;
   wire n_124;
   wire n_125;
   wire n_126;
   wire n_127;
   wire n_128;
   wire n_129;
   wire n_130;
   wire n_131;
   wire n_132;
   wire n_133;
   wire n_134;
   wire n_135;
   wire n_136;
   wire n_137;
   wire n_138;
   wire n_139;
   wire n_140;
   wire n_141;
   wire n_142;
   wire n_143;
   wire n_144;
   wire n_145;
   wire n_146;
   wire n_147;
   wire n_148;
   wire n_149;
   wire n_150;
   wire n_151;
   wire n_152;
   wire n_153;
   wire n_154;
   wire n_155;
   wire n_156;
   wire n_157;
   wire n_158;
   wire n_159;
   wire n_160;
   wire n_161;
   wire n_162;
   wire n_163;
   wire n_164;
   wire n_165;
   wire n_166;
   wire n_167;
   wire n_168;
   wire n_169;
   wire n_170;
   wire n_171;
   wire n_173;
   wire n_174;
   wire n_175;
   wire n_176;
   wire n_177;
   wire n_178;
   wire n_179;
   wire n_180;
   wire n_181;
   wire n_182;
   wire n_183;
   wire n_184;
   wire n_185;
   wire n_186;
   wire preload_miso;
   wire tx_bit_reg;
   wire wr_ack_reg;
   wire wren;

   BUFX1 FE_OFC88_n_80 (.A(n_80),
	.Y(FE_OFN88_n_80));
   BUFX1 FE_OFC87_n_88 (.A(n_88),
	.Y(FE_OFN87_n_88));
   BUFX20 FE_OFC83_FE_OFN71_n_87 (.A(FE_OFN71_n_87),
	.Y(FE_OFN92_FE_OFN71_n_87));
   BUFX1 FE_OFC84_n_42 (.A(n_42),
	.Y(FE_OFN84_n_42));
   BUFX3 FE_OFC83_preload_miso (.A(preload_miso),
	.Y(FE_OFN83_preload_miso));
   BUFX3 FE_OFC82_sh_reg_1 (.A(sh_reg[1]),
	.Y(FE_OFN91_sh_reg_1));
   BUFX3 FE_OFC80_sh_reg_15 (.A(sh_reg[15]),
	.Y(FE_OFN89_sh_reg_15));
   CLKBUFX8 FE_OFC79_n_85 (.A(FE_OFN69_n_85),
	.Y(FE_OFN88_n));
   INVX1 FE_OFC78_n_65 (.A(FE_OFN77_n_65),
	.Y(FE_OFN78_n_65));
   INVX1 FE_OFC77_n_65 (.A(n_65),
	.Y(FE_OFN77_n_65));
   CLKBUFX8 FE_OFC76_n_133 (.A(FE_OFN75_n_133),
	.Y(FE_OFN76_n_133));
   CLKBUFX8 FE_OFC75_n_133 (.A(n_133),
	.Y(FE_OFN75_n_133));
   BUFX12 FE_OFC74_n_103 (.A(FE_OFN73_n_103),
	.Y(FE_OFN74_n_103));
   CLKBUFX8 FE_OFC73_n_103 (.A(n_103),
	.Y(FE_OFN73_n_103));
   BUFX16 FE_OFC71_n_87 (.A(n_87),
	.Y(FE_OFN71_n_87));
   CLKBUFX16 FE_OFC70_n_85 (.A(FE_OFN88_n),
	.Y(FE_OFN70_n_85));
   BUFX3 FE_OFC69_n_85 (.A(n_85),
	.Y(FE_OFN69_n_85));
   CLKBUFX16 FE_OFC68_spi_miso_o (.A(FE_OFN68_spi_miso_o),
	.Y(spi_miso_o));
   CLKBUFX8 FE_OFC67_n_186 (.A(FE_OFN65_n_186),
	.Y(FE_OFN67_n_186));
   CLKBUFX8 FE_OFC66_n_186 (.A(FE_OFN65_n_186),
	.Y(FE_OFN66_n_186));
   BUFX16 FE_OFC65_n_186 (.A(FE_OFN64_n_186),
	.Y(FE_OFN65_n_186));
   BUFX16 FE_OFC64_n_186 (.A(FE_OFN63_n_186),
	.Y(FE_OFN64_n_186));
   CLKBUFX8 FE_OFC63_n_186 (.A(FE_OFN62_n_186),
	.Y(FE_OFN63_n_186));
   BUFX12 FE_OFC62_n_186 (.A(FE_OFN61_n_186),
	.Y(FE_OFN62_n_186));
   BUFX16 FE_OFC61_n_186 (.A(n_186),
	.Y(FE_OFN61_n_186));
   CLKBUFX8 FE_OFC60_n_131 (.A(FE_OFN59_n_131),
	.Y(FE_OFN60_n_131));
   CLKBUFX8 FE_OFC59_n_131 (.A(n_131),
	.Y(FE_OFN59_n_131));
   CLKBUFX8 FE_OFC58_n_105 (.A(n_105),
	.Y(FE_OFN58_n_105));
   BUFX3 FE_OFC56_n_18 (.A(n_18),
	.Y(FE_OFN56_n_18));
   INVX1 FE_OFC55_n_10 (.A(FE_OFN54_n_10),
	.Y(FE_OFN55_n_10));
   INVX1 FE_OFC54_n_10 (.A(n_10),
	.Y(FE_OFN54_n_10));
   BUFX3 FE_OFC51_di_reg_8 (.A(di_reg[8]),
	.Y(FE_OFN51_di_reg_8));
   BUFX3 FE_OFC50_sh_reg_0 (.A(sh_reg[0]),
	.Y(FE_OFN50_sh_reg_0));
   BUFX3 FE_OFC48_sh_reg_3 (.A(sh_reg[3]),
	.Y(FE_OFN48_sh_reg_3));
   BUFX3 FE_OFC47_sh_reg_4 (.A(sh_reg[4]),
	.Y(FE_OFN47_sh_reg_4));
   BUFX3 FE_OFC46_sh_reg_5 (.A(sh_reg[5]),
	.Y(FE_OFN46_sh_reg_5));
   BUFX3 FE_OFC45_sh_reg_6 (.A(sh_reg[6]),
	.Y(FE_OFN45_sh_reg_6));
   BUFX3 FE_OFC44_sh_reg_7 (.A(sh_reg[7]),
	.Y(FE_OFN44_sh_reg_7));
   BUFX3 FE_OFC42_sh_reg_10 (.A(sh_reg[10]),
	.Y(FE_OFN42_sh_reg_10));
   BUFX3 FE_OFC41_sh_reg_12 (.A(sh_reg[12]),
	.Y(FE_OFN41_sh_reg_12));
   BUFX3 FE_OFC40_sh_reg_14 (.A(sh_reg[14]),
	.Y(FE_OFN40_sh_reg_14));
   BUFX3 FE_OFC39_sh_reg_16 (.A(sh_reg[16]),
	.Y(FE_OFN39_sh_reg_16));
   BUFX3 FE_OFC38_sh_reg_17 (.A(sh_reg[17]),
	.Y(FE_OFN38_sh_reg_17));
   BUFX3 FE_OFC37_sh_reg_19 (.A(sh_reg[19]),
	.Y(FE_OFN37_sh_reg_19));
   BUFX3 FE_OFC36_sh_reg_21 (.A(sh_reg[21]),
	.Y(FE_OFN36_sh_reg_21));
   BUFX4 FE_OFC35_sh_reg_22 (.A(sh_reg[22]),
	.Y(FE_OFN35_sh_reg_22));
   BUFX3 FE_OFC34_sh_reg_23 (.A(sh_reg[23]),
	.Y(FE_OFN34_sh_reg_23));
   CLKBUFX20 FE_OFC33_do_o_0 (.A(FE_OFN33_do_o_0),
	.Y(do_o[0]));
   CLKBUFX16 FE_OFC32_do_o_1 (.A(FE_OFN32_do_o_1),
	.Y(do_o[1]));
   CLKBUFX16 FE_OFC31_do_o_2 (.A(FE_OFN31_do_o_2),
	.Y(do_o[2]));
   CLKBUFX16 FE_OFC30_do_o_3 (.A(FE_OFN30_do_o_3),
	.Y(do_o[3]));
   CLKBUFX16 FE_OFC29_do_o_4 (.A(FE_OFN29_do_o_4),
	.Y(do_o[4]));
   CLKBUFX16 FE_OFC28_do_o_5 (.A(FE_OFN28_do_o_5),
	.Y(do_o[5]));
   CLKBUFX16 FE_OFC27_do_o_6 (.A(FE_OFN27_do_o_6),
	.Y(do_o[6]));
   CLKBUFX20 FE_OFC26_do_o_7 (.A(FE_OFN26_do_o_7),
	.Y(do_o[7]));
   CLKBUFX20 FE_OFC25_do_o_8 (.A(FE_OFN25_do_o_8),
	.Y(do_o[8]));
   CLKBUFX20 FE_OFC24_do_o_9 (.A(FE_OFN24_do_o_9),
	.Y(do_o[9]));
   CLKBUFX20 FE_OFC23_do_o_10 (.A(FE_OFN23_do_o_10),
	.Y(do_o[10]));
   CLKBUFX16 FE_OFC22_do_o_11 (.A(FE_OFN22_do_o_11),
	.Y(do_o[11]));
   CLKBUFX16 FE_OFC21_do_o_12 (.A(FE_OFN21_do_o_12),
	.Y(do_o[12]));
   CLKBUFX16 FE_OFC20_do_o_13 (.A(FE_OFN20_do_o_13),
	.Y(do_o[13]));
   CLKBUFX16 FE_OFC19_do_o_14 (.A(FE_OFN19_do_o_14),
	.Y(do_o[14]));
   CLKBUFX16 FE_OFC18_do_o_15 (.A(FE_OFN18_do_o_15),
	.Y(do_o[15]));
   CLKBUFX16 FE_OFC17_do_o_16 (.A(FE_OFN17_do_o_16),
	.Y(do_o[16]));
   CLKBUFX16 FE_OFC16_do_o_17 (.A(FE_OFN16_do_o_17),
	.Y(do_o[17]));
   CLKBUFX16 FE_OFC15_do_o_18 (.A(FE_OFN15_do_o_18),
	.Y(do_o[18]));
   CLKBUFX16 FE_OFC14_do_o_19 (.A(FE_OFN14_do_o_19),
	.Y(do_o[19]));
   CLKBUFX20 FE_OFC13_do_o_20 (.A(FE_OFN13_do_o_20),
	.Y(do_o[20]));
   CLKBUFX20 FE_OFC12_do_o_21 (.A(FE_OFN12_do_o_21),
	.Y(do_o[21]));
   CLKBUFX20 FE_OFC11_do_o_22 (.A(FE_OFN11_do_o_22),
	.Y(do_o[22]));
   BUFX3 FE_OFC10_do_o_23 (.A(do_o[23]),
	.Y(FE_OFN10_do_o_23));
   CLKBUFX16 FE_OFC9_do_o_23 (.A(FE_OFN9_do_o_23),
	.Y(do_o[23]));
   CLKBUFX16 FE_OFC8_do_valid_o (.A(FE_OFN7_do_valid_o),
	.Y(do_valid_o));
   BUFX12 FE_OFC7_do_valid_o (.A(FE_OFN7_do_valid_o),
	.Y(FE_OFN8_do_valid_o));
   BUFX12 FE_OFC6_do_valid_o (.A(FE_OFN6_do_valid_o),
	.Y(FE_OFN7_do_valid_o));
   BUFX12 FE_OFC5_do_valid_o (.A(FE_OFN5_do_valid_o),
	.Y(FE_OFN6_do_valid_o));
   CLKBUFX8 FE_OFC4_clk_i (.A(FE_OFN3_clk_i),
	.Y(FE_OFN4_clk_i));
   CLKBUFX8 FE_OFC3_clk_i (.A(clk_i),
	.Y(FE_OFN3_clk_i));
   CLKBUFX8 FE_OFC2_spi_sck_i (.A(FE_OFN1_spi_sck_i),
	.Y(FE_OFN2_spi_sck_i));
   CLKBUFX8 FE_OFC1_spi_sck_i (.A(FE_OFN0_spi_sck_i),
	.Y(FE_OFN1_spi_sck_i));
   BUFX16 FE_OFC0_spi_sck_i (.A(spi_sck_i),
	.Y(FE_OFN0_spi_sck_i));
   INVX2 FE_DBTC0_do_valid_o (.A(FE_OFN6_do_valid_o),
	.Y(FE_DBTN0_do_valid_o));
   SDFFSX1 wren_reg (.CK(FE_OFN3_clk_i),
	.D(FE_DBTN0_do_valid_o),
	.Q(wren),
	.QN(UNCONNECTED),
	.SE(n_135),
	.SI(wren),
	.SN(FE_OFN62_n_186));
   DFFSX1 \sh_reg_reg[23]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_174),
	.Q(UNCONNECTED0),
	.QN(sh_reg[23]),
	.SN(FE_OFN62_n_186));
   DFFSX4 \sh_reg_reg[11]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_179),
	.Q(UNCONNECTED1),
	.QN(sh_reg[11]),
	.SN(FE_OFN63_n_186));
   DFFSX4 \sh_reg_reg[8]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_185),
	.Q(UNCONNECTED2),
	.QN(sh_reg[8]),
	.SN(FE_OFN63_n_186));
   DFFSX2 \di_reg_reg[23]  (.CK(FE_OFN3_clk_i),
	.D(n_180),
	.Q(UNCONNECTED3),
	.QN(di_reg[23]),
	.SN(FE_OFN64_n_186));
   DFFSX1 \sh_reg_reg[1]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_182),
	.Q(UNCONNECTED4),
	.QN(sh_reg[1]),
	.SN(FE_OFN61_n_186));
   DFFSX2 \sh_reg_reg[18]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_176),
	.Q(UNCONNECTED5),
	.QN(sh_reg[18]),
	.SN(FE_OFN66_n_186));
   DFFSX2 \sh_reg_reg[20]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_175),
	.Q(UNCONNECTED6),
	.QN(sh_reg[20]),
	.SN(FE_OFN66_n_186));
   DFFSX2 \sh_reg_reg[13]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_184),
	.Q(UNCONNECTED7),
	.QN(sh_reg[13]),
	.SN(FE_OFN65_n_186));
   DFFSX1 \sh_reg_reg[10]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_181),
	.Q(UNCONNECTED8),
	.QN(sh_reg[10]),
	.SN(FE_OFN62_n_186));
   DFFSX1 \sh_reg_reg[15]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_178),
	.Q(UNCONNECTED9),
	.QN(sh_reg[15]),
	.SN(FE_OFN65_n_186));
   DFFSX4 \sh_reg_reg[9]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_183),
	.Q(UNCONNECTED10),
	.QN(sh_reg[9]),
	.SN(FE_OFN62_n_186));
   DFFSX1 \sh_reg_reg[17]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_177),
	.Q(UNCONNECTED11),
	.QN(sh_reg[17]),
	.SN(FE_OFN66_n_186));
   DFFNSX2 tx_bit_reg_reg (.CKN(FE_OFN0_spi_sck_i),
	.D(n_164),
	.Q(UNCONNECTED12),
	.QN(tx_bit_reg),
	.SN(FE_OFN61_n_186));
   DFFSX2 do_transfer_reg_reg (.CK(FE_OFN0_spi_sck_i),
	.D(n_165),
	.Q(UNCONNECTED13),
	.QN(do_transfer_reg),
	.SN(FE_OFN61_n_186));
   DFFSX1 \di_reg_reg[0]  (.CK(FE_OFN4_clk_i),
	.D(n_167),
	.Q(di_reg[0]),
	.QN(UNCONNECTED14),
	.SN(FE_OFN61_n_186));
   DFFSX1 \di_reg_reg[5]  (.CK(FE_OFN4_clk_i),
	.D(n_138),
	.Q(di_reg[5]),
	.QN(UNCONNECTED15),
	.SN(FE_OFN64_n_186));
   DFFSX1 \di_reg_reg[17]  (.CK(FE_OFN3_clk_i),
	.D(n_152),
	.Q(di_reg[17]),
	.QN(UNCONNECTED16),
	.SN(FE_OFN66_n_186));
   DFFSX1 \di_reg_reg[18]  (.CK(FE_OFN4_clk_i),
	.D(n_139),
	.Q(di_reg[18]),
	.QN(UNCONNECTED17),
	.SN(FE_OFN67_n_186));
   DFFSX1 \di_reg_reg[19]  (.CK(FE_OFN4_clk_i),
	.D(n_137),
	.Q(di_reg[19]),
	.QN(UNCONNECTED18),
	.SN(FE_OFN67_n_186));
   DFFSX1 \di_reg_reg[20]  (.CK(FE_OFN4_clk_i),
	.D(n_163),
	.Q(di_reg[20]),
	.QN(UNCONNECTED19),
	.SN(FE_OFN67_n_186));
   DFFSX1 \di_reg_reg[6]  (.CK(FE_OFN4_clk_i),
	.D(n_136),
	.Q(di_reg[6]),
	.QN(UNCONNECTED20),
	.SN(FE_OFN64_n_186));
   DFFSX1 \di_reg_reg[21]  (.CK(FE_OFN3_clk_i),
	.D(n_170),
	.Q(di_reg[21]),
	.QN(UNCONNECTED21),
	.SN(FE_OFN66_n_186));
   DFFSX1 \di_reg_reg[7]  (.CK(FE_OFN4_clk_i),
	.D(n_169),
	.Q(di_reg[7]),
	.QN(UNCONNECTED22),
	.SN(FE_OFN64_n_186));
   DFFSX2 \di_reg_reg[22]  (.CK(FE_OFN3_clk_i),
	.D(n_168),
	.Q(di_reg[22]),
	.QN(UNCONNECTED23),
	.SN(FE_OFN66_n_186));
   DFFSX1 \di_reg_reg[10]  (.CK(FE_OFN3_clk_i),
	.D(n_162),
	.Q(di_reg[10]),
	.QN(UNCONNECTED24),
	.SN(FE_OFN63_n_186));
   DFFSX1 \di_reg_reg[8]  (.CK(FE_OFN3_clk_i),
	.D(n_166),
	.Q(di_reg[8]),
	.QN(UNCONNECTED25),
	.SN(FE_OFN62_n_186));
   DFFSX1 \di_reg_reg[9]  (.CK(FE_OFN3_clk_i),
	.D(n_173),
	.Q(di_reg[9]),
	.QN(UNCONNECTED26),
	.SN(FE_OFN62_n_186));
   DFFSX1 \di_reg_reg[14]  (.CK(FE_OFN4_clk_i),
	.D(n_156),
	.Q(di_reg[14]),
	.QN(UNCONNECTED27),
	.SN(FE_OFN65_n_186));
   DFFSX1 \di_reg_reg[11]  (.CK(FE_OFN4_clk_i),
	.D(n_161),
	.Q(di_reg[11]),
	.QN(UNCONNECTED28),
	.SN(FE_OFN64_n_186));
   DFFSX1 \sh_reg_reg[14]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_154),
	.Q(UNCONNECTED29),
	.QN(sh_reg[14]),
	.SN(FE_OFN65_n_186));
   DFFSX1 \di_reg_reg[3]  (.CK(FE_OFN3_clk_i),
	.D(n_158),
	.Q(di_reg[3]),
	.QN(UNCONNECTED30),
	.SN(FE_OFN61_n_186));
   DFFSX1 \di_reg_reg[2]  (.CK(FE_OFN4_clk_i),
	.D(n_157),
	.Q(di_reg[2]),
	.QN(UNCONNECTED31),
	.SN(FE_OFN61_n_186));
   DFFSX1 \di_reg_reg[15]  (.CK(FE_OFN4_clk_i),
	.D(n_145),
	.Q(di_reg[15]),
	.QN(UNCONNECTED32),
	.SN(FE_OFN65_n_186));
   DFFSX1 \di_reg_reg[13]  (.CK(FE_OFN3_clk_i),
	.D(n_159),
	.Q(di_reg[13]),
	.QN(UNCONNECTED33),
	.SN(FE_OFN62_n_186));
   DFFSX1 \di_reg_reg[1]  (.CK(FE_OFN4_clk_i),
	.D(n_153),
	.Q(di_reg[1]),
	.QN(UNCONNECTED34),
	.SN(FE_OFN61_n_186));
   DFFSX1 \di_reg_reg[16]  (.CK(FE_OFN4_clk_i),
	.D(n_151),
	.Q(di_reg[16]),
	.QN(UNCONNECTED35),
	.SN(FE_OFN65_n_186));
   DFFSX1 \di_reg_reg[4]  (.CK(FE_OFN4_clk_i),
	.D(n_155),
	.Q(di_reg[4]),
	.QN(UNCONNECTED36),
	.SN(FE_OFN64_n_186));
   DFFSX1 \di_reg_reg[12]  (.CK(FE_OFN4_clk_i),
	.D(n_160),
	.Q(di_reg[12]),
	.QN(UNCONNECTED37),
	.SN(FE_OFN65_n_186));
   DFFSX2 \sh_reg_reg[2]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_148),
	.Q(UNCONNECTED38),
	.QN(sh_reg[2]),
	.SN(FE_OFN61_n_186));
   DFFSX1 \sh_reg_reg[3]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_147),
	.Q(UNCONNECTED39),
	.QN(sh_reg[3]),
	.SN(FE_OFN61_n_186));
   DFFSX1 \sh_reg_reg[4]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_146),
	.Q(UNCONNECTED40),
	.QN(sh_reg[4]),
	.SN(FE_OFN61_n_186));
   DFFSX1 \sh_reg_reg[5]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_150),
	.Q(UNCONNECTED41),
	.QN(sh_reg[5]),
	.SN(FE_OFN64_n_186));
   DFFSX1 \sh_reg_reg[6]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_144),
	.Q(UNCONNECTED42),
	.QN(sh_reg[6]),
	.SN(FE_OFN64_n_186));
   DFFSX1 \sh_reg_reg[7]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_143),
	.Q(UNCONNECTED43),
	.QN(sh_reg[7]),
	.SN(FE_OFN63_n_186));
   DFFSX1 \sh_reg_reg[12]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_142),
	.Q(UNCONNECTED44),
	.QN(sh_reg[12]),
	.SN(FE_OFN64_n_186));
   DFFSX1 \sh_reg_reg[16]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_149),
	.Q(UNCONNECTED45),
	.QN(sh_reg[16]),
	.SN(FE_OFN65_n_186));
   DFFSX1 \sh_reg_reg[19]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_171),
	.Q(UNCONNECTED46),
	.QN(sh_reg[19]),
	.SN(FE_OFN67_n_186));
   DFFSX1 \sh_reg_reg[21]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_140),
	.Q(UNCONNECTED47),
	.QN(sh_reg[21]),
	.SN(FE_OFN67_n_186));
   DFFSX1 \sh_reg_reg[22]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_141),
	.Q(UNCONNECTED48),
	.QN(sh_reg[22]),
	.SN(FE_OFN66_n_186));
   AND2X1 g3347 (.A(n_130),
	.B(n_58),
	.Y(n_185));
   AND2X1 g3345 (.A(n_126),
	.B(n_44),
	.Y(n_184));
   AND2X1 g3348 (.A(n_129),
	.B(n_61),
	.Y(n_183));
   AND2X1 g3346 (.A(n_132),
	.B(n_59),
	.Y(n_182));
   AND2X1 g3349 (.A(n_128),
	.B(n_56),
	.Y(n_181));
   MXI2X2 g3379 (.A(FE_OFN10_do_o_23),
	.B(di_reg[23]),
	.S0(FE_DBTN0_do_valid_o),
	.Y(n_180));
   AND2X1 g3350 (.A(n_127),
	.B(n_55),
	.Y(n_179));
   AND2X1 g3352 (.A(n_125),
	.B(n_52),
	.Y(n_178));
   AND2X1 g3353 (.A(n_124),
	.B(n_51),
	.Y(n_177));
   AND2X1 g3354 (.A(n_123),
	.B(n_54),
	.Y(n_176));
   AND2X1 g3355 (.A(n_122),
	.B(n_60),
	.Y(n_175));
   AND2X1 g3356 (.A(n_134),
	.B(n_50),
	.Y(n_174));
   AOI2BB2X1 g3382 (.A0N(FE_OFN6_do_valid_o),
	.A1N(di_reg[9]),
	.B0(FE_OFN6_do_valid_o),
	.B1(do_o[9]),
	.Y(n_173));
   AND2X1 g3420 (.A(n_114),
	.B(n_91),
	.Y(n_171));
   AOI2BB2X1 g3375 (.A0N(FE_OFN6_do_valid_o),
	.A1N(di_reg[21]),
	.B0(FE_OFN6_do_valid_o),
	.B1(do_o[21]),
	.Y(n_170));
   AOI2BB2X1 g3376 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[7]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[7]),
	.Y(n_169));
   AOI2BB2X2 g3377 (.A0N(FE_OFN6_do_valid_o),
	.A1N(di_reg[22]),
	.B0(FE_OFN6_do_valid_o),
	.B1(do_o[22]),
	.Y(n_168));
   AOI2BB2X2 g3378 (.A0N(do_valid_o),
	.A1N(di_reg[0]),
	.B0(do_valid_o),
	.B1(do_o[0]),
	.Y(n_167));
   AOI2BB2X2 g3380 (.A0N(FE_OFN6_do_valid_o),
	.A1N(FE_OFN51_di_reg_8),
	.B0(FE_OFN6_do_valid_o),
	.B1(do_o[8]),
	.Y(n_166));
   NOR2X1 g3351 (.A(n_107),
	.B(FE_OFN71_n_87),
	.Y(n_165));
   AOI222X4 g3381 (.A0(FE_OFN73_n_103),
	.A1(tx_bit_reg),
	.B0(FE_OFN75_n_133),
	.B1(FE_OFN34_sh_reg_23),
	.C0(n_100),
	.C1(di_reg[23]),
	.Y(n_164));
   AOI2BB2X2 g3374 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[20]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[20]),
	.Y(n_163));
   AOI2BB2X1 g3383 (.A0N(FE_OFN6_do_valid_o),
	.A1N(di_reg[10]),
	.B0(FE_OFN6_do_valid_o),
	.B1(do_o[10]),
	.Y(n_162));
   AOI2BB2X1 g3384 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[11]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[11]),
	.Y(n_161));
   AOI2BB2X1 g3385 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[12]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[12]),
	.Y(n_160));
   AOI2BB2X2 g3386 (.A0N(FE_OFN6_do_valid_o),
	.A1N(di_reg[13]),
	.B0(FE_OFN6_do_valid_o),
	.B1(do_o[13]),
	.Y(n_159));
   AOI2BB2X2 g3387 (.A0N(FE_OFN7_do_valid_o),
	.A1N(di_reg[3]),
	.B0(FE_OFN7_do_valid_o),
	.B1(do_o[3]),
	.Y(n_158));
   AOI2BB2X1 g3388 (.A0N(FE_OFN7_do_valid_o),
	.A1N(di_reg[2]),
	.B0(FE_OFN7_do_valid_o),
	.B1(do_o[2]),
	.Y(n_157));
   AOI2BB2X1 g3389 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[14]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[14]),
	.Y(n_156));
   AOI2BB2X2 g3390 (.A0N(FE_OFN6_do_valid_o),
	.A1N(di_reg[4]),
	.B0(FE_OFN7_do_valid_o),
	.B1(do_o[4]),
	.Y(n_155));
   AND2X1 g3400 (.A(n_112),
	.B(n_104),
	.Y(n_154));
   AOI2BB2X1 g3369 (.A0N(FE_OFN7_do_valid_o),
	.A1N(di_reg[1]),
	.B0(FE_OFN7_do_valid_o),
	.B1(do_o[1]),
	.Y(n_153));
   AOI2BB2X1 g3393 (.A0N(FE_OFN6_do_valid_o),
	.A1N(di_reg[17]),
	.B0(FE_OFN6_do_valid_o),
	.B1(do_o[17]),
	.Y(n_152));
   AOI2BB2X2 g3392 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[16]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[16]),
	.Y(n_151));
   AND2X1 g3394 (.A(n_116),
	.B(n_97),
	.Y(n_150));
   AND2X1 g3395 (.A(n_111),
	.B(n_92),
	.Y(n_149));
   AND2X1 g3397 (.A(n_119),
	.B(n_102),
	.Y(n_148));
   AND2X1 g3398 (.A(n_118),
	.B(n_96),
	.Y(n_147));
   AND2X1 g3399 (.A(n_117),
	.B(n_94),
	.Y(n_146));
   AOI2BB2X1 g3391 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[15]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[15]),
	.Y(n_145));
   AND2X1 g3401 (.A(n_121),
	.B(n_93),
	.Y(n_144));
   AND2X1 g3402 (.A(n_110),
	.B(n_99),
	.Y(n_143));
   AND2X1 g3403 (.A(n_113),
	.B(n_95),
	.Y(n_142));
   AND2X1 g3409 (.A(n_108),
	.B(n_89),
	.Y(n_141));
   AND2X1 g3408 (.A(n_109),
	.B(n_90),
	.Y(n_140));
   AOI2BB2X2 g3370 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[18]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[18]),
	.Y(n_139));
   AOI2BB2X1 g3371 (.A0N(FE_OFN7_do_valid_o),
	.A1N(di_reg[5]),
	.B0(FE_OFN7_do_valid_o),
	.B1(do_o[5]),
	.Y(n_138));
   AOI2BB2X1 g3372 (.A0N(FE_OFN8_do_valid_o),
	.A1N(di_reg[19]),
	.B0(FE_OFN8_do_valid_o),
	.B1(do_o[19]),
	.Y(n_137));
   AOI2BB2X2 g3373 (.A0N(FE_OFN7_do_valid_o),
	.A1N(di_reg[6]),
	.B0(FE_OFN7_do_valid_o),
	.B1(do_o[6]),
	.Y(n_136));
   NOR2X1 g3405 (.A(FE_OFN6_do_valid_o),
	.B(wr_ack_reg),
	.Y(n_135));
   AOI2BB2X2 g3407 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[22]),
	.B0(FE_OFN76_n_133),
	.B1(FE_OFN35_sh_reg_22),
	.Y(n_134));
   AOI2BB2X2 g3410 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[0]),
	.B0(n_133),
	.B1(FE_OFN50_sh_reg_0),
	.Y(n_132));
   AOI2BB2X2 g3411 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[7]),
	.B0(FE_OFN75_n_133),
	.B1(FE_OFN44_sh_reg_7),
	.Y(n_130));
   AOI2BB2X2 g3412 (.A0N(FE_OFN59_n_131),
	.A1N(FE_OFN51_di_reg_8),
	.B0(FE_OFN75_n_133),
	.B1(sh_reg[8]),
	.Y(n_129));
   AOI2BB2X2 g3413 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[9]),
	.B0(FE_OFN75_n_133),
	.B1(sh_reg[9]),
	.Y(n_128));
   AOI2BB2X2 g3414 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[10]),
	.B0(FE_OFN75_n_133),
	.B1(FE_OFN42_sh_reg_10),
	.Y(n_127));
   AOI2BB2X2 g3415 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[12]),
	.B0(FE_OFN76_n_133),
	.B1(FE_OFN41_sh_reg_12),
	.Y(n_126));
   AOI2BB2X1 g3416 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[14]),
	.B0(FE_OFN76_n_133),
	.B1(FE_OFN40_sh_reg_14),
	.Y(n_125));
   AOI2BB2X1 g3417 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[16]),
	.B0(FE_OFN76_n_133),
	.B1(FE_OFN39_sh_reg_16),
	.Y(n_124));
   AOI2BB2X2 g3418 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[17]),
	.B0(FE_OFN76_n_133),
	.B1(FE_OFN38_sh_reg_17),
	.Y(n_123));
   AOI2BB2X2 g3419 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[19]),
	.B0(FE_OFN76_n_133),
	.B1(FE_OFN37_sh_reg_19),
	.Y(n_122));
   NAND2XL g3454 (.A(FE_OFN75_n_133),
	.B(FE_OFN46_sh_reg_5),
	.Y(n_121));
   NAND2XL g3450 (.A(n_133),
	.B(FE_OFN91_sh_reg_1),
	.Y(n_119));
   NAND2XL g3451 (.A(n_133),
	.B(sh_reg[2]),
	.Y(n_118));
   NAND2XL g3452 (.A(FE_OFN75_n_133),
	.B(FE_OFN48_sh_reg_3),
	.Y(n_117));
   NAND2XL g3453 (.A(FE_OFN75_n_133),
	.B(FE_OFN47_sh_reg_4),
	.Y(n_116));
   NAND2XL g3459 (.A(FE_OFN76_n_133),
	.B(sh_reg[18]),
	.Y(n_114));
   NAND2XL g3456 (.A(FE_OFN75_n_133),
	.B(sh_reg[11]),
	.Y(n_113));
   NAND2XL g3457 (.A(FE_OFN76_n_133),
	.B(sh_reg[13]),
	.Y(n_112));
   NAND2XL g3458 (.A(FE_OFN76_n_133),
	.B(FE_OFN89_sh_reg_15),
	.Y(n_111));
   NAND2XL g3455 (.A(FE_OFN75_n_133),
	.B(FE_OFN45_sh_reg_6),
	.Y(n_110));
   NAND2XL g3460 (.A(FE_OFN76_n_133),
	.B(sh_reg[20]),
	.Y(n_109));
   NAND2XL g3461 (.A(FE_OFN76_n_133),
	.B(FE_OFN36_sh_reg_21),
	.Y(n_108));
   OAI2BB1X1 g3396 (.A0N(n_41),
	.A1N(n_14),
	.B0(n_106),
	.Y(n_107));
   DFFSX2 wr_ack_reg_reg (.CK(FE_OFN1_spi_sck_i),
	.D(n_101),
	.Q(UNCONNECTED49),
	.QN(wr_ack_reg),
	.SN(FE_OFN62_n_186));
   DFFSX4 \do_buffer_reg_reg[9]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_69),
	.Q(UNCONNECTED50),
	.QN(FE_OFN24_do_o_9),
	.SN(FE_OFN64_n_186));
   DFFSX4 \do_buffer_reg_reg[13]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_68),
	.Q(UNCONNECTED51),
	.QN(FE_OFN20_do_o_13),
	.SN(FE_OFN65_n_186));
   DFFSX4 \do_buffer_reg_reg[23]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_78),
	.Q(UNCONNECTED52),
	.QN(FE_OFN9_do_o_23),
	.SN(FE_OFN66_n_186));
   DFFSX4 \do_buffer_reg_reg[16]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_82),
	.Q(UNCONNECTED53),
	.QN(FE_OFN17_do_o_16),
	.SN(FE_OFN65_n_186));
   DFFSX4 \do_buffer_reg_reg[1]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_74),
	.Q(UNCONNECTED54),
	.QN(FE_OFN32_do_o_1),
	.SN(FE_OFN61_n_186));
   DFFSX4 \do_buffer_reg_reg[17]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_77),
	.Q(UNCONNECTED55),
	.QN(FE_OFN16_do_o_17),
	.SN(FE_OFN65_n_186));
   DFFSX4 \do_buffer_reg_reg[20]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_81),
	.Q(UNCONNECTED56),
	.QN(FE_OFN13_do_o_20),
	.SN(FE_OFN67_n_186));
   DFFSX4 \do_buffer_reg_reg[18]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_84),
	.Q(UNCONNECTED57),
	.QN(FE_OFN15_do_o_18),
	.SN(FE_OFN65_n_186));
   DFFSX4 \do_buffer_reg_reg[15]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_64),
	.Q(UNCONNECTED58),
	.QN(FE_OFN18_do_o_15),
	.SN(FE_OFN65_n_186));
   DFFSX4 \do_buffer_reg_reg[19]  (.CK(FE_OFN2_spi_sck_i),
	.D(FE_OFN87_n_88),
	.Q(UNCONNECTED59),
	.QN(FE_OFN14_do_o_19),
	.SN(FE_OFN67_n_186));
   DFFSX1 \sh_reg_reg[0]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_98),
	.Q(UNCONNECTED60),
	.QN(sh_reg[0]),
	.SN(FE_OFN61_n_186));
   DFFSX4 \do_buffer_reg_reg[5]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_70),
	.Q(UNCONNECTED61),
	.QN(FE_OFN28_do_o_5),
	.SN(FE_OFN64_n_186));
   DFFSX4 \do_buffer_reg_reg[22]  (.CK(FE_OFN2_spi_sck_i),
	.D(n_79),
	.Q(UNCONNECTED62),
	.QN(FE_OFN11_do_o_22),
	.SN(FE_OFN67_n_186));
   DFFSX4 \do_buffer_reg_reg[0]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_75),
	.Q(UNCONNECTED63),
	.QN(FE_OFN33_do_o_0),
	.SN(FE_OFN61_n_186));
   DFFSX4 \do_buffer_reg_reg[2]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_66),
	.Q(UNCONNECTED64),
	.QN(FE_OFN31_do_o_2),
	.SN(FE_OFN61_n_186));
   DFFSX4 \do_buffer_reg_reg[3]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_72),
	.Q(UNCONNECTED65),
	.QN(FE_OFN30_do_o_3),
	.SN(FE_OFN64_n_186));
   DFFSX4 \do_buffer_reg_reg[4]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_71),
	.Q(UNCONNECTED66),
	.QN(FE_OFN29_do_o_4),
	.SN(FE_OFN64_n_186));
   DFFSX4 \do_buffer_reg_reg[6]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_62),
	.Q(UNCONNECTED67),
	.QN(FE_OFN27_do_o_6),
	.SN(FE_OFN64_n_186));
   DFFSX4 \do_buffer_reg_reg[7]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_73),
	.Q(UNCONNECTED68),
	.QN(FE_OFN26_do_o_7),
	.SN(FE_OFN64_n_186));
   DFFSX4 \do_buffer_reg_reg[8]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_67),
	.Q(UNCONNECTED69),
	.QN(FE_OFN25_do_o_8),
	.SN(FE_OFN63_n_186));
   DFFSX4 \do_buffer_reg_reg[10]  (.CK(FE_OFN1_spi_sck_i),
	.D(FE_OFN78_n_65),
	.Q(UNCONNECTED70),
	.QN(FE_OFN23_do_o_10),
	.SN(FE_OFN62_n_186));
   DFFSX4 \do_buffer_reg_reg[11]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_76),
	.Q(UNCONNECTED71),
	.QN(FE_OFN22_do_o_11),
	.SN(FE_OFN63_n_186));
   DFFSX4 \do_buffer_reg_reg[12]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_86),
	.Q(UNCONNECTED72),
	.QN(FE_OFN21_do_o_12),
	.SN(FE_OFN65_n_186));
   DFFSX4 \do_buffer_reg_reg[14]  (.CK(FE_OFN1_spi_sck_i),
	.D(n_63),
	.Q(UNCONNECTED73),
	.QN(FE_OFN19_do_o_14),
	.SN(FE_OFN65_n_186));
   DFFSX4 \do_buffer_reg_reg[21]  (.CK(FE_OFN2_spi_sck_i),
	.D(FE_OFN88_n_80),
	.Q(UNCONNECTED74),
	.QN(FE_OFN12_do_o_21),
	.SN(FE_OFN66_n_186));
   DFFSX2 \state_reg_reg[4]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_83),
	.Q(UNCONNECTED75),
	.QN(state_reg[4]),
	.SN(FE_OFN58_n_105));
   DFFSX2 do_valid_o_reg_reg (.CK(FE_OFN3_clk_i),
	.D(n_57),
	.Q(UNCONNECTED76),
	.QN(FE_OFN5_do_valid_o),
	.SN(FE_OFN62_n_186));
   OAI2BB1X1 g3462 (.A0N(n_38),
	.A1N(n_43),
	.B0(do_transfer_reg),
	.Y(n_106));
   DFFSX4 \state_reg_reg[2]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_47),
	.Q(UNCONNECTED77),
	.QN(state_reg[2]),
	.SN(FE_OFN58_n_105));
   DFFSX2 \state_reg_reg[1]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_45),
	.Q(UNCONNECTED78),
	.QN(state_reg[1]),
	.SN(FE_OFN58_n_105));
   DFFSX4 \state_reg_reg[0]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_49),
	.Q(UNCONNECTED79),
	.QN(state_reg[0]),
	.SN(FE_OFN58_n_105));
   DFFSX4 \state_reg_reg[3]  (.CK(FE_OFN0_spi_sck_i),
	.D(n_53),
	.Q(state_reg[3]),
	.QN(UNCONNECTED80),
	.SN(FE_OFN58_n_105));
   OR2X4 g3497 (.A(n_48),
	.B(n_16),
	.Y(n_133));
   AOI2BB2X2 g3472 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[13]),
	.B0(FE_OFN74_n_103),
	.B1(FE_OFN40_sh_reg_14),
	.Y(n_104));
   AOI2BB2X1 g3465 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[1]),
	.B0(n_103),
	.B1(sh_reg[2]),
	.Y(n_102));
   AOI21X1 g3463 (.A0(FE_OFN73_n_103),
	.A1(wr_ack_reg),
	.B0(n_100),
	.Y(n_101));
   AOI2BB2X1 g3470 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[6]),
	.B0(FE_OFN73_n_103),
	.B1(FE_OFN44_sh_reg_7),
	.Y(n_99));
   AOI32X4 g3464 (.A0(n_30),
	.A1(spi_mosi_i),
	.A2(FE_OFN61_n_186),
	.B0(n_103),
	.B1(FE_OFN50_sh_reg_0),
	.Y(n_98));
   AOI2BB2X1 g3468 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[4]),
	.B0(FE_OFN73_n_103),
	.B1(FE_OFN46_sh_reg_5),
	.Y(n_97));
   AOI2BB2X1 g3466 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[2]),
	.B0(FE_OFN73_n_103),
	.B1(FE_OFN48_sh_reg_3),
	.Y(n_96));
   AOI2BB2X1 g3471 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[11]),
	.B0(FE_OFN74_n_103),
	.B1(FE_OFN41_sh_reg_12),
	.Y(n_95));
   AOI2BB2X2 g3467 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[3]),
	.B0(FE_OFN73_n_103),
	.B1(FE_OFN47_sh_reg_4),
	.Y(n_94));
   AOI2BB2X1 g3469 (.A0N(FE_OFN59_n_131),
	.A1N(di_reg[5]),
	.B0(FE_OFN73_n_103),
	.B1(FE_OFN45_sh_reg_6),
	.Y(n_93));
   AOI2BB2X2 g3473 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[15]),
	.B0(FE_OFN74_n_103),
	.B1(FE_OFN39_sh_reg_16),
	.Y(n_92));
   AOI2BB2X2 g3474 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[18]),
	.B0(FE_OFN74_n_103),
	.B1(FE_OFN37_sh_reg_19),
	.Y(n_91));
   AOI2BB2X1 g3475 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[20]),
	.B0(FE_OFN74_n_103),
	.B1(FE_OFN36_sh_reg_21),
	.Y(n_90));
   AOI2BB2X2 g3476 (.A0N(FE_OFN60_n_131),
	.A1N(di_reg[21]),
	.B0(FE_OFN74_n_103),
	.B1(FE_OFN35_sh_reg_22),
	.Y(n_89));
   AOI22X2 g3477 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(sh_reg[18]),
	.B0(FE_OFN70_n_85),
	.B1(do_o[19]),
	.Y(n_88));
   AOI22X4 g3478 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(sh_reg[11]),
	.B0(FE_OFN70_n_85),
	.B1(do_o[12]),
	.Y(n_86));
   AOI22X2 g3479 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN38_sh_reg_17),
	.B0(FE_OFN70_n_85),
	.B1(do_o[18]),
	.Y(n_84));
   AND2X1 g3492 (.A(n_40),
	.B(FE_OFN84_n_42),
	.Y(n_83));
   AOI22X4 g3498 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN89_sh_reg_15),
	.B0(FE_OFN70_n_85),
	.B1(do_o[16]),
	.Y(n_82));
   AOI22X4 g3499 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN37_sh_reg_19),
	.B0(FE_OFN70_n_85),
	.B1(do_o[20]),
	.Y(n_81));
   AOI22X2 g3500 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(sh_reg[20]),
	.B0(FE_OFN70_n_85),
	.B1(do_o[21]),
	.Y(n_80));
   AOI22X4 g3501 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN36_sh_reg_21),
	.B0(FE_OFN70_n_85),
	.B1(do_o[22]),
	.Y(n_79));
   AOI22X4 g3502 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN35_sh_reg_22),
	.B0(FE_OFN70_n_85),
	.B1(FE_OFN10_do_o_23),
	.Y(n_78));
   AOI22X2 g3503 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN39_sh_reg_16),
	.B0(FE_OFN70_n_85),
	.B1(do_o[17]),
	.Y(n_77));
   AOI22X2 g3504 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN42_sh_reg_10),
	.B0(FE_OFN70_n_85),
	.B1(do_o[11]),
	.Y(n_76));
   AOI22X2 g3505 (.A0(n_87),
	.A1(spi_mosi_i),
	.B0(n_85),
	.B1(do_o[0]),
	.Y(n_75));
   AOI22X4 g3506 (.A0(FE_OFN71_n_87),
	.A1(FE_OFN50_sh_reg_0),
	.B0(n_85),
	.B1(do_o[1]),
	.Y(n_74));
   AOI22X4 g3507 (.A0(FE_OFN71_n_87),
	.A1(FE_OFN45_sh_reg_6),
	.B0(FE_OFN88_n),
	.B1(do_o[7]),
	.Y(n_73));
   AOI22X2 g3508 (.A0(FE_OFN71_n_87),
	.A1(sh_reg[2]),
	.B0(FE_OFN69_n_85),
	.B1(do_o[3]),
	.Y(n_72));
   AOI22X4 g3509 (.A0(FE_OFN71_n_87),
	.A1(FE_OFN48_sh_reg_3),
	.B0(FE_OFN88_n),
	.B1(do_o[4]),
	.Y(n_71));
   AOI22X4 g3510 (.A0(FE_OFN71_n_87),
	.A1(FE_OFN47_sh_reg_4),
	.B0(FE_OFN88_n),
	.B1(do_o[5]),
	.Y(n_70));
   AOI22X4 g3511 (.A0(FE_OFN71_n_87),
	.A1(sh_reg[8]),
	.B0(FE_OFN70_n_85),
	.B1(do_o[9]),
	.Y(n_69));
   AOI22X4 g3512 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN41_sh_reg_12),
	.B0(FE_OFN70_n_85),
	.B1(do_o[13]),
	.Y(n_68));
   AOI22X4 g3513 (.A0(FE_OFN71_n_87),
	.A1(FE_OFN44_sh_reg_7),
	.B0(FE_OFN70_n_85),
	.B1(do_o[8]),
	.Y(n_67));
   AOI22X4 g3514 (.A0(FE_OFN71_n_87),
	.A1(FE_OFN91_sh_reg_1),
	.B0(FE_OFN69_n_85),
	.B1(do_o[2]),
	.Y(n_66));
   AOI22X4 g3515 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(sh_reg[9]),
	.B0(FE_OFN70_n_85),
	.B1(do_o[10]),
	.Y(n_65));
   AOI22X2 g3516 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(FE_OFN40_sh_reg_14),
	.B0(FE_OFN70_n_85),
	.B1(do_o[15]),
	.Y(n_64));
   AOI22X2 g3517 (.A0(FE_OFN92_FE_OFN71_n_87),
	.A1(sh_reg[13]),
	.B0(FE_OFN70_n_85),
	.B1(do_o[14]),
	.Y(n_63));
   AOI22X2 g3518 (.A0(FE_OFN71_n_87),
	.A1(FE_OFN46_sh_reg_5),
	.B0(FE_OFN88_n),
	.B1(do_o[6]),
	.Y(n_62));
   NAND2XL g3484 (.A(FE_OFN74_n_103),
	.B(sh_reg[9]),
	.Y(n_61));
   NAND2XL g3481 (.A(FE_OFN74_n_103),
	.B(sh_reg[20]),
	.Y(n_60));
   NAND2XL g3482 (.A(n_103),
	.B(FE_OFN91_sh_reg_1),
	.Y(n_59));
   NAND2XL g3483 (.A(FE_OFN74_n_103),
	.B(sh_reg[8]),
	.Y(n_58));
   OAI2BB1XL g3480 (.A0N(do_valid_D),
	.A1N(do_valid_C),
	.B0(FE_OFN62_n_186),
	.Y(n_57));
   NAND2XL g3485 (.A(FE_OFN74_n_103),
	.B(FE_OFN42_sh_reg_10),
	.Y(n_56));
   NAND2XL g3486 (.A(FE_OFN74_n_103),
	.B(sh_reg[11]),
	.Y(n_55));
   NAND2XL g3487 (.A(FE_OFN74_n_103),
	.B(sh_reg[18]),
	.Y(n_54));
   AOI2BB1X1 g3529 (.A0N(n_22),
	.A1N(n_39),
	.B0(n_34),
	.Y(n_53));
   NAND2XL g3489 (.A(FE_OFN74_n_103),
	.B(FE_OFN89_sh_reg_15),
	.Y(n_52));
   NAND2XL g3490 (.A(FE_OFN74_n_103),
	.B(FE_OFN38_sh_reg_17),
	.Y(n_51));
   NAND2XL g3491 (.A(FE_OFN74_n_103),
	.B(FE_OFN34_sh_reg_23),
	.Y(n_50));
   NOR2X1 g3520 (.A(n_46),
	.B(n_21),
	.Y(n_49));
   AND2X1 g3522 (.A(n_37),
	.B(state_reg[4]),
	.Y(n_48));
   NOR2X1 g3523 (.A(n_46),
	.B(n_32),
	.Y(n_47));
   AOI2BB1X1 g3527 (.A0N(n_20),
	.A1N(FE_OFN55_n_10),
	.B0(n_46),
	.Y(n_45));
   NAND2XL g3488 (.A(FE_OFN74_n_103),
	.B(sh_reg[13]),
	.Y(n_44));
   INVX1 g3519 (.A(FE_OFN73_n_103),
	.Y(n_43));
   AOI22X2 g3528 (.A0(n_25),
	.A1(n_35),
	.B0(n_41),
	.B1(n_19),
	.Y(n_42));
   NAND3X1 g3526 (.A(n_36),
	.B(n_39),
	.C(state_reg[4]),
	.Y(n_40));
   AOI2BB1X2 g3525 (.A0N(n_11),
	.A1N(rst),
	.B0(n_29),
	.Y(n_38));
   INVX1 g3530 (.A(FE_OFN59_n_131),
	.Y(n_100));
   AND2X4 g3524 (.A(n_31),
	.B(n_186),
	.Y(n_103));
   OR2X1 g3532 (.A(n_36),
	.B(n_35),
	.Y(n_37));
   AND2X1 g3538 (.A(n_26),
	.B(n_15),
	.Y(n_34));
   AND2X2 g3533 (.A(n_36),
	.B(n_6),
	.Y(n_46));
   AND2X4 g3534 (.A(n_28),
	.B(FE_OFN61_n_186),
	.Y(n_85));
   AND2X4 g3521 (.A(FE_OFN56_n_18),
	.B(n_186),
	.Y(FE_OFN68_spi_miso_o));
   DFFSX1 do_valid_D_reg (.CK(FE_OFN3_clk_i),
	.D(do_valid_C),
	.Q(do_valid_D),
	.QN(UNCONNECTED81),
	.SN(FE_OFN62_n_186));
   AND2X1 g3539 (.A(n_17),
	.B(state_reg[2]),
	.Y(n_32));
   OR2X2 g3536 (.A(n_13),
	.B(n_8),
	.Y(n_131));
   AND2X4 g3535 (.A(n_27),
	.B(n_186),
	.Y(n_87));
   INVXL g3537 (.A(n_30),
	.Y(n_31));
   AND3X2 g3540 (.A(n_41),
	.B(state_reg[2]),
	.C(n_5),
	.Y(n_29));
   INVXL g3544 (.A(n_27),
	.Y(n_28));
   OAI2BB1XL g3550 (.A0N(n_39),
	.A1N(n_24),
	.B0(n_23),
	.Y(n_26));
   OAI2BB1X1 g3553 (.A0N(state_reg[4]),
	.A1N(n_24),
	.B0(n_23),
	.Y(n_25));
   CLKINVX2 g3545 (.A(n_22),
	.Y(n_36));
   NOR3X2 g3542 (.A(n_20),
	.B(n_19),
	.C(state_reg[0]),
	.Y(n_21));
   MX2X1 g3541 (.A(tx_bit_reg),
	.B(di_reg[23]),
	.S0(FE_OFN83_preload_miso),
	.Y(n_18));
   NOR2X1 g3546 (.A(n_20),
	.B(n_9),
	.Y(n_17));
   OR3X1 g3543 (.A(n_12),
	.B(state_reg[3]),
	.C(n_3),
	.Y(n_30));
   DFFSX1 do_valid_C_reg (.CK(FE_OFN3_clk_i),
	.D(do_valid_B),
	.Q(do_valid_C),
	.QN(UNCONNECTED82),
	.SN(FE_OFN62_n_186));
   AND2X1 g3551 (.A(n_7),
	.B(n_15),
	.Y(n_16));
   INVXL g3555 (.A(n_23),
	.Y(n_14));
   AOI2BB1X2 g3552 (.A0N(n_24),
	.A1N(wren),
	.B0(n_12),
	.Y(n_13));
   NOR2X2 g3548 (.A(n_11),
	.B(state_reg[0]),
	.Y(n_27));
   NAND2X2 g3549 (.A(n_12),
	.B(n_186),
	.Y(n_22));
   AOI22X4 g3554 (.A0(n_9),
	.A1(state_reg[2]),
	.B0(state_reg[1]),
	.B1(state_reg[0]),
	.Y(n_10));
   OR2X2 g3559 (.A(n_24),
	.B(n_4),
	.Y(n_23));
   CLKINVX2 g3560 (.A(n_8),
	.Y(n_41));
   NAND2XL g3561 (.A(n_19),
	.B(state_reg[3]),
	.Y(n_7));
   DFFSX1 do_valid_B_reg (.CK(FE_OFN3_clk_i),
	.D(do_valid_A),
	.Q(do_valid_B),
	.QN(UNCONNECTED83),
	.SN(FE_OFN62_n_186));
   NOR2X4 g3558 (.A(n_35),
	.B(n_15),
	.Y(n_20));
   OR3X2 g3562 (.A(n_6),
	.B(state_reg[2]),
	.C(n_5),
	.Y(n_11));
   NAND2X2 g3564 (.A(n_15),
	.B(state_reg[3]),
	.Y(n_8));
   AND2X4 g3563 (.A(n_19),
	.B(n_4),
	.Y(n_12));
   CLKINVX2 g3565 (.A(n_19),
	.Y(n_24));
   DFFNSRX1 preload_miso_reg (.CKN(FE_OFN0_spi_sck_i),
	.D(1'b1),
	.Q(UNCONNECTED84),
	.QN(preload_miso),
	.RN(n_0),
	.SN(FE_OFN61_n_186));
   OR2X2 g3569 (.A(n_39),
	.B(state_reg[4]),
	.Y(n_6));
   AND2X4 g3570 (.A(state_reg[3]),
	.B(FE_OFN62_n_186),
	.Y(n_35));
   AND2X4 g3571 (.A(n_3),
	.B(FE_OFN61_n_186),
	.Y(n_15));
   DFFSX1 do_valid_A_reg (.CK(FE_OFN3_clk_i),
	.D(n_2),
	.Q(do_valid_A),
	.QN(UNCONNECTED85),
	.SN(FE_OFN62_n_186));
   AND2X2 g3567 (.A(n_4),
	.B(n_5),
	.Y(n_9));
   AND2X4 g3568 (.A(n_1),
	.B(n_5),
	.Y(n_19));
   NOR2X2 g3572 (.A(spi_ssel_i),
	.B(rst),
	.Y(n_105));
   INVXL g3578 (.A(do_transfer_reg),
	.Y(n_2));
   INVX1 g3577 (.A(state_reg[4]),
	.Y(n_3));
   INVX2 g3574 (.A(state_reg[1]),
	.Y(n_5));
   CLKINVX8 g3580 (.A(rst),
	.Y(n_186));
   INVXL g3575 (.A(state_reg[2]),
	.Y(n_1));
   INVXL g3573 (.A(spi_ssel_i),
	.Y(n_0));
   CLKINVX2 g3576 (.A(state_reg[0]),
	.Y(n_4));
   INVX2 g3579 (.A(state_reg[3]),
	.Y(n_39));
endmodule

