

primitive udp_retn (out, n2, n4, clk, xRN, xSN);
   output out;  
   input  n2, n4, clk, xRN, xSN;

   table
// n2, n4, clk, xRN, xSN
//
   0   ?    1    1   1 : 0;
   1   ?    1    1   1 : 1;
   ?   0    0    1   1 : 0;
   ?   1    0    1   1 : 1;
   ?   ?    ?    ?   0 : 1;
   ?   ?    ?    0   1 : 0;

   ?   1    0    1   ? : 1; //reducing pessimisim
   1   ?    1    1   ? : 1;
   1   1    ?    1   ? : 1;
   ?   0    0    ?   1 : 0;
   0   ?    1    ?   1 : 0;
   0   0    ?    ?   1 : 0;
   endtable
endprimitive // udp_retn


primitive udp_tlat_PWR (out, in, hold, clr_, set_, VDD, VSS, NOTIFIER);
   output out;  
   input  in, hold, clr_, set_, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  hold  clr_   set_  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   1  0   1   ?   1  0  ?  : ?  :  1  ; // 
   0  0   ?   1   1  0  ?  : ?  :  0  ; // 
   1  *   1   ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0  *   ?   1   1  0  ?  : 0  :  0  ; // reduce pessimism
   *  1   ?   ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   1  0  ?  : ?  :  1  ; // set output
   ?  1   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   1  ?   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   1  0  ?  : ?  :  0  ; // reset output
   ?  1   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   0  ?   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat


primitive udp_jkff (out, j, k, clk, clr_, set_, NOTIFIER);
   output out;  
   input  j, k, clk, clr_, set_, NOTIFIER;
   reg    out;

   table

// j  k  clk  clr_   set_  NOT  : Qt : Qt+1
//       
   0  0  r   1   1   ?   : ?  :  -  ; // output remains same
   0  1  r   ?   1   ?   : ?  :  0  ; // clock in 0
   1  0  r   1   ?   ?   : ?  :  1  ; // clock in 1
//   1  1  r   ?   1   ?   : 1  :  0  ; // clock in 0
   ?  1  r   ?   1   ?   : 1  :  0  ; // clock in 0
//   1  1  r   1   ?   ?   : 0  :  1  ; // clock in 1
   1  ?  r   1   ?   ?   : 0  :  1  ; // clock in 1
   ?  0  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  ?  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   ?  ?  f   ?   ?   ?   : ?  :  -  ; // no changes on negedge clk
   *  ?  b   ?   ?   ?   : ?  :  -  ; // no changes when j switches
   *  0  x   1   ?   ?   : 1  :  1  ; // no changes when j switches
   ?  *  b   ?   ?   ?   : ?  :  -  ; // no changes when k switches
   0  *  x   ?   1   ?   : 0  :  0  ; // no changes when k switches
   ?  ?  ?   ?   0   ?   : ?  :  1  ; // set output
   ?  ?  b   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  0  x   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?  ?   0   1   ?   : ?  :  0  ; // reset output
   ?  ?  b   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  ?  x   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?  ?   ?   ?   *   : ?  :  x  ; // any notifier change

   endtable
endprimitive // udp_jkff


primitive udp_dff (out, in, clk, clr_, set_, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  NOT  : Qt : Qt+1
//
   0  r   ?   1   ?   : ?  :  0  ; // clock in 0
   1  r   1   ?   ?   : ?  :  1  ; // clock in 1
   1  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   ?  f   ?   ?   ?   : ?  :  -  ; // no changes on negedge clk
   *  b   ?   ?   ?   : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   ?   : ?  :  1  ; // set output
   ?  b   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   1  x   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   ?   : ?  :  0  ; // reset output
   ?  b   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  x   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_dff


primitive udp_sedff_PWR (out, in, clk, clr_, si, se, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, si, se,  en, VDD, VSS, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  si  se  en  VDD  VSS  NOTIFIER : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   0  0  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   1  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   0  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   ?  ?  *  : ?  :  x; // any notifier changed
      ?    ?    0     ?   ?   ?   1  0  ?  : ?  :  0;     
      ?    r    ?     0   1   ?   1  0  ?  : ?  :  0;     
      ?    r    1     1   1   ?   1  0  ?  : ?  :  1;
      ?    b    1     ?   *   ?   1  0  ?  : ?  :  -; // no changes when se switches
      ?    b    1     *   ?   ?   1  0  ?  : ?  :  -; // no changes when si switches
      *    b    1     ?   ?   ?   1  0  ?  : ?  :  -; // no changes when in switches
      *    ?    ?     ?   0   0   1  0  ?  : 0  :  0; // no changes when in switches
      ?    ?    ?     *   0   0   1  0  ?  : 0  :  0; // no changes when in switches
      ?    b    1     ?   ?   *   1  0  ?  : ?  :  -; // no changes when en switches
      ?    b    *     ?   ?   ?   1  0  ?  : 0  :  0; // no changes when en switches
      ?    ?    *     ?   0   0   1  0  ?  : 0  :  0; // no changes when en switches
      ?    b    ?     ?   ?   *   1  0  ?  : 0  :  0; // no changes when en switches
      ?    b    ?     ?   *   ?   1  0  ?  : 0  :  0; // no changes when en switches
      ?    b    ?     *   ?   ?   1  0  ?  : 0  :  0; // no changes when en switches
      *    b    ?     ?   ?   ?   1  0  ?  : 0  :  0; // no changes when en switches
      ?  (10)   ?     ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      ?    *    1     1   1   ?   1  0  ?  : 1  :  1;
      ?    x    1     1   1   ?   1  0  ?  : 1  :  1;
      ?    *    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    x    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    *    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    x    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    *    ?     0   ?   0   1  0  ?  : 0  :  0;
      ?    x    ?     0   ?   0   1  0  ?  : 0  :  0;
      0    r    ?     0   ?   1   1  0  ?  : ?  :  0 ; 
      0    *    ?     0   ?   ?   1  0  ?  : 0  :  0 ; 
      0    x    ?     0   ?   ?   1  0  ?  : 0  :  0 ; 
      1    r    1     1   ?   1   1  0  ?  : ?  :  1 ; 
      1    *    1     1   ?   ?   1  0  ?  : 1  :  1 ; 
      1    x    1     1   ?   ?   1  0  ?  : 1  :  1 ; 
      ?  (x0)   ?     ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   0   1   1  0  ?  : ?  :  1;
      0    r    ?     ?   0   1   1  0  ?  : ?  :  0;
      ?    *    ?     ?   0   0   1  0  ?  : ?  :  -;
      ?    x    1     ?   0   0   1  0  ?  : ?  :  -;
      1    x    1     ?   0   ?   1  0  ?  : 1  :  1; // no changes when in switches
      0    x    ?     ?   0   ?   1  0  ?  : 0  :  0; // no changes when in switches
      1    x    ?     ?   0   0   1  0  ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   0   ?   1  0  ?  : 1  :  1; // reduce pessimism
      0    *    ?     ?   0   ?   1  0  ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive  /* udp_sedff_PWR */
   


primitive udp_dff_PWR (out, in, clk, clr_, set_, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   0  r   ?   1   1  0  ?  : ?  :  0  ; // clock in 0
   1  r   1   ?   1  0  ?  : ?  :  1  ; // clock in 1
   1  *   1   ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0  *   ?   1   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?  f   ?   ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *  b   ?   ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   1  0  ?  : ?  :  1  ; // set output
   ?  b   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   1  x   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   1  0  ?  : ?  :  0  ; // reset output
   ?  b   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   0  x   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_dff

primitive udp_ph2p (LOUT, CLK1, CLK2, DATA1, DATA2, SET, RESET);
    output LOUT; reg LOUT;
    input CLK1;
    input CLK2;
    input DATA1;
    input DATA2;
    input SET;
    input RESET;
    table
    //  **NOTE that for input combo's not given , the output will be x=unknown
    //  CLK1 CLK2 DATA1 DATA2 SET  RESET : state : LOUT
         ?    ?    ?     ?     0    0    :   ?   :  0 ;// Reset only on
         ?    ?    ?     ?     1    1    :   ?   :  1 ;// Set only on
         ?    ?    ?     ?     1    0    :   ?   :  1 ;// Both S/R active
         ?    ?    ?     ?     1    X    :   ?   :  1 ;// Set on, reset X
         0    0    ?     ?     0    1    :   ?   :  - ;// No Change
         1    0    0     ?     0    ?    :   ?   :  0 ;// First Port Function
         1    0    1     ?     ?    1    :   ?   :  1 ;
         0    1    ?     0     0    ?    :   ?   :  0 ;// Second Port Function
         0    1    ?     1     ?    1    :   ?   :  1 ;
         1    1    0     0     0    ?    :   ?   :  0 ;// Both Clocks ON
         1    1    1     1     ?    1    :   ?   :  1 ;
         ?    0    0     ?     0    1    :   0   :  - ;// Clocks Unknown
         ?    0    1     ?     0    1    :   1   :  - ;
         ?    1    0     0     0    ?    :   ?   :  0 ;
         ?    1    1     1     ?    1    :   ?   :  1 ;
         0    ?    ?     0     0    1    :   0   :  - ;
         0    ?    ?     1     0    1    :   1   :  - ;
         1    ?    0     0     0    ?    :   ?   :  0 ;
         1    ?    1     1     ?    1    :   ?   :  1 ;
         ?    ?    0     0     0    1    :   0   :  - ;
         ?    ?    1     1     0    1    :   1   :  - ;
         0    0    ?     ?     0    X    :   0   :  - ;// Reset Unknown
         ?    ?    0     0     0    X    :   0   :  - ;
         ?    0    0     ?     0    X    :   0   :  - ;
         0    ?    ?     0     0    X    :   0   :  - ;
         0    0    ?     ?     X    1    :   1   :  - ;// Set Unknown
         ?    ?    1     1     X    1    :   1   :  - ;
         ?    0    1     ?     X    1    :   1   :  - ;
         0    ?    ?     1     X    1    :   1   :  - ;
    endtable
endprimitive

primitive udp_ph1p (LOUT, CLK, DATA, SET, RESET);
    output LOUT; reg LOUT;
    input CLK;
    input DATA;
    input SET;
    input RESET;
    table
    //  CLK  DATA  SET  RESET : state : LOUT
         ?    ?     0    0    :   ?   :  0 ;// Reset only on
         ?    ?     1    ?    :   ?   :  1 ;// Set on (Set Dominant)
         0    ?     0    1    :   ?   :  - ;// No Change
         1    0     0    ?    :   ?   :  0 ;// First Port Function
         1    1     ?    1    :   ?   :  1 ;
         ?    0     0    1    :   0   :  - ;// Clock Unknown
         ?    1     0    1    :   1   :  - ;
         0    ?     0    X    :   0   :  - ;// Reset Unknown
         ?    0     0    X    :   0   :  - ;
         0    ?     X    1    :   1   :  - ;// Set Unknown
         ?    1     X    1    :   1   :  - ;
    endtable
endprimitive

primitive udp_ph1p_pwr (LOUT, VDD, VSS, CLK, DATA, SET, RESET);
    output LOUT; reg LOUT;
    input CLK;
    input DATA;
    input SET;
    input RESET;
    input VDD, VSS;
    table
    //  VDD   VSS  CLK  DATA  SET  RESET : state : LOUT
         1     0    ?    ?     0    0    :   ?   :  0 ;// Reset only on
         1     0    ?    ?     1    ?    :   ?   :  1 ;// Set on (Set Dominant)
         1     0    0    ?     0    1    :   ?   :  - ;// No Change
         1     0    1    0     0    ?    :   ?   :  0 ;// First Port Function
         1     0    1    1     ?    1    :   ?   :  1 ;
         1     0    ?    0     0    1    :   0   :  - ;// Clock Unknown
         1     0    ?    1     0    1    :   1   :  - ;
         1     0    0    ?     0    X    :   0   :  - ;// Reset Unknown
         1     0    ?    0     0    X    :   0   :  - ;
         1     0    0    ?     X    1    :   1   :  - ;// Set Unknown
         1     0    ?    1     X    1    :   1   :  - ;
	 0     ?    ?    ?     ?    ?    :   ?   :  x ;//Power down
	 ?     1    ?    ?     ?    ?    :   ?   :  x ;//Power down
    endtable
endprimitive



primitive udp_retn_pwr (out, VDD, VSS, n2, n4, clk, xRN, xSN);
   output out;  
   input  VDD, VSS, n2, n4, clk, xRN, xSN;

   table
// VDD, VSS, n2, n4, clk, xRN, xSN 
//
    1    0   0   ?    1    1   1 : 0;
    1    0   1   ?    1    1   1 : 1;
    1    0   ?   0    0    1   1 : 0;
    1    0   ?   1    0    1   1 : 1;
    1    0   ?   ?    ?    ?   0 : 1;
    1    0   ?   ?    ?    0   1 : 0;
    1    0   ?   1    0    1   ? : 1; //reducing pessimisim
    1    0   1   ?    1    1   ? : 1;
    1    0   1   1    ?    1   ? : 1;
    1    0   ?   0    0    ?   1 : 0;
    1    0   0   ?    1    ?   1 : 0;
    1    0   0   0    ?    ?   1 : 0;

   endtable
endprimitive // udp_mux


primitive udp_mux2 (out, in0, in1, sel);
   output out;  
   input  in0, in1, sel;

   table

// in0 in1  sel :  out
//
   1  ?   0  :  1 ;
   0  ?   0  :  0 ;
   ?  1   1  :  1 ;
   ?  0   1  :  0 ;
   0  0   x  :  0 ;
   1  1   x  :  1 ;

   endtable
endprimitive // udp_mux2


primitive udp_edfft_PWR (out, in, clk, clr_, set_, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, en, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  en  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   ?   r    0      1     ?   1  0  ?  : ?  :  0  ; // clock in 0
   0   r    ?      1     1   1  0  ?  : ?  :  0  ; // clock in 0
   ?   r    ?      0     ?   1  0  ?  : ?  :  1  ; // clock in 1
   1   r    1      ?     1   1  0  ?  : ?  :  1  ; // clock in 1
   ?   *    1      1     0   1  0  ?  : ?  :  -  ; // no changes, not enabled
   ?   *    ?      1     0   1  0  ?  : 0  :  0  ; // no changes, not enabled
   ?   *    1      ?     0   1  0  ?  : 1  :  1  ; // no changes, not enabled
   ?  (x0)  ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes
   ?  (x1)  ?      0     ?   1  0  ?  : 1  :  1  ; // no changes
   1   *    1      ?     ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0   *    ?      1     ?   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?   f    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *   b    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   1   x    1      ?     ?   1  0  ?  : 1  :  1  ; // no changes when in switches
   ?   x    1      ?     0   1  0  ?  : 1  :  1  ; // no changes when in switches
   0   x    ?      1     ?   1  0  ?  : 0  :  0  ; // no changes when in switches
   ?   x    ?      1     0   1  0  ?  : 0  :  0  ; // no changes when in switches
   ?   b    ?      ?     *   1  0  ?  : ?  :  -  ; // no changes when en switches
   ?   b    *      ?     ?   1  0  ?  : ?  :  -  ; // no changes when clr_ switches
   ?   x    0      1     ?   1  0  ?  : 0  :  0  ; // no changes when clr_ switches
   ?   b    ?      *     ?   1  0  ?  : ?  :  -  ; // no changes when set_ switches
   ?   x    ?      0     ?   1  0  ?  : 1  :  1  ; // no changes when set_ switches
   ?   ?    ?      ?     ?   0  0  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   1  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   0  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_edfft


primitive udp_tlatrf2_PWR (out, in1, w1w, in2, w2w, VDD, VSS, NOTIFIER);
   output out;  
   input  in1, w1w, VDD, VSS, NOTIFIER;
   input  in2, w2w;
   reg    out;

   table

// in1 ww1 in2 ww2  VDD  VSS  NOTIFIER  : Qt : Qt+1
//	     
   ?   ?    ?   ?    0  0  ?  : ?  :  x  ; 
   ?   ?    ?   ?    1  1  ?  : ?  :  x  ; 
   ?   ?    ?   ?    0  1  ?  : ?  :  x  ; 
   ?   ?    ?   ?    ?  ?  *  : ?  :  x  ; //
   1   1    ?   0    1  0  ?  : ?  :  1  ; //
   1   *    ?   0    1  0  ?  : 1  :  1  ; //
   0   1    ?   0    1  0  ?  : ?  :  0  ; //
   0   *    ?   0    1  0  ?  : 0  :  0  ; //
   ?   0    1   1    1  0  ?  : ?  :  1  ; //
   ?   0    1   *    1  0  ?  : 1  :  1  ; //
   ?   0    0   1    1  0  ?  : ?  :  0  ; //
   ?   0    0   *    1  0  ?  : 0  :  0  ; //
   *   0    ?   0    1  0  ?  : ?  :  -  ; //
   ?   0    *   0    1  0  ?  : ?  :  -  ; //
   1   *    1   1    1  0  ?  : ?  :  1  ; //
   1   1    1   *    1  0  ?  : ?  :  1  ; //
   0   *    0   1    1  0  ?  : ?  :  0  ; //
   0   1    0   *    1  0  ?  : ?  :  0  ; //
   0   1    0   1    1  0  ?  : ?  :  0  ; //
   1   1    1   1    1  0  ?  : ?  :  1  ; //



   endtable
endprimitive // udp_tlatrf2



primitive udp_outrf (out, in, rwn, rw);
   output out;  
   input  in, rwn, rw;

   table

// in  rwn   rw   : out;
//	     	  
   0   0     ?    : 1  ; // 
   1   ?     1    : 1  ; // 
   ?   1     0    : 0  ; // 
   1   ?     0    : 0  ; // 
   0   1     ?    : 0  ; // 

   endtable
endprimitive // udp_outrf



primitive udp_sedfft (out, in, clk, clr_, si, se, en, NOTIFIER);
   output out;  
   input  in, clk, clr_, si, se,  en, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  si  se  en  NOT : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   *  : ?  :  x; // any notifier changed
      ?    r    ?     0   1   ?   ?  : ?  :  0;     
      ?    r    ?     1   1   ?   ?  : ?  :  1;
      ?    b    ?     ?   *   ?   ?  : ?  :  -; // no changes when se switches
      ?    b    ?     *   ?   ?   ?  : ?  :  -; // no changes when si switches
      *    b    ?     ?   ?   ?   ?  : ?  :  -; // no changes when in switches
      ?    b    ?     ?   ?   *   ?  : ?  :  -; // no changes when en switches
      ?    b    *     ?   ?   ?   ?  : ?  :  -; // no changes when clr switches
      0    r    ?     0   ?   1   ?  : ?  :  0 ; 
      1    r    1     1   ?   1   ?  : ?  :  1 ; 
      ?    r    ?     0   ?   0   ?  : 0  :  0;
      ?    x    ?     0   ?   0   ?  : 0  :  0;
      ?    r    1     1   ?   0   ?  : 1  :  1;
      ?    x    1     1   ?   0   ?  : 1  :  1;
      ?    *    1     ?   0   0   ?  : ?  :  -;
      ?    *    ?     1   1   ?   ?  : 1  :  1;
      1    *    1     1   ?   ?   ?  : 1  :  1;
      ?    *    ?     0   1   ?   ?  : 0  :  0;
      ?    *    0     0   ?   ?   ?  : 0  :  0;
      0    *    ?     0   ?   ?   ?  : 0  :  0;
      ?    x    1     ?   0   0   ?  : ?  :  -;
      ?    *    ?     ?   0   0   ?  : 0  :  0;
      ?    x    ?     ?   0   0   ?  : 0  :  0;
      ?    x    ?     1   1   ?   ?  : 1  :  1;
      1    x    1     1   ?   ?   ?  : 1  :  1;
      ?    x    ?     0   1   ?   ?  : 0  :  0;
      ?    x    0     0   ?   ?   ?  : 0  :  0;
      0    x    ?     0   ?   ?   ?  : 0  :  0;
      ?    r    0     0   ?   ?   ?  : ?  :  0 ; 
      ?   (?0)  ?     ?   ?   ?   ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   0   1   ?  : ?  :  1;
      0    r    ?     ?   0   1   ?  : ?  :  0;
      ?    r    0     ?   0   ?   ?  : ?  :  0;
      ?    x    0     ?   0   ?   ?  : 0  :  0;
      1    x    1     ?   0   ?   ?  : 1  :  1; // no changes when in switches
      0    x    ?     ?   0   ?   ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   0   ?   ?  : 1  :  1; // reduce pessimism
      0    *    ?     ?   0   ?   ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive  /* udp_sedfft */
   


primitive udp_edff_PWR (out, in, clk, clr_, set_, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, en, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  en  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   0   r    ?      1     1   1  0  ?  : ?  :  0  ; // clock in 0
   1   r    1      ?     1   1  0  ?  : ?  :  1  ; // clock in 1
   ?   *    ?      ?     0   1  0  ?  : ?  :  -  ; // no changes, not enabled
   *   ?    ?      ?     0   1  0  ?  : ?  :  -  ; // no changes, not enabled
   1   *    1      ?     ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0   *    ?      1     ?   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?   f    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *   b    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   1   x    1      ?     ?   1  0  ?  : 1  :  1  ; // no changes when in switches
   0   x    ?      1     ?   1  0  ?  : 0  :  0  ; // no changes when in switches
   ?   b    ?      ?     *   1  0  ?  : ?  :  -  ; // no changes when en switches
   ?   x    1      1     0   1  0  ?  : ?  :  -  ; // no changes when en is disabled
   ?   ?    ?      0     ?   1  0  ?  : ?  :  1  ; // set output
   ?   b    1      *     ?   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?   ?    1      *     0   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?   ?    0      1     ?   1  0  ?  : ?  :  0  ; // reset output
   ?   b    *      1     ?   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?   ?    *      1     0   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?   ?    ?      ?     ?   0  0  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   1  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   0  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_edff


primitive udp_jkff_PWR (out, j, k, clk, clr_, set_, VDD, VSS, NOTIFIER);
   output out;  
   input  j, k, clk, clr_, set_, VDD, VSS, NOTIFIER;
   reg    out;

   table

// j  k  clk  clr_   set_  VDD  VSS  NOTIFIER  : Qt : Qt+1
//       
   0  0  r   1   1   1  0  ?  : ?  :  -  ; // output remains same
   0  1  r   ?   1   1  0  ?  : ?  :  0  ; // clock in 0
   1  0  r   1   ?   1  0  ?  : ?  :  1  ; // clock in 1
//   1  1  r   ?   1   1  0  ?  : 1  :  0  ; // clock in 0
   ?  1  r   ?   1   1  0  ?  : 1  :  0  ; // clock in 0
//   1  1  r   1   ?   1  0  ?  : 0  :  1  ; // clock in 1
   1  ?  r   1   ?   1  0  ?  : 0  :  1  ; // clock in 1
   ?  0  *   1   ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0  ?  *   ?   1   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?  ?  f   ?   ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *  ?  b   ?   ?   1  0  ?  : ?  :  -  ; // no changes when j switches
   *  0  x   1   ?   1  0  ?  : 1  :  1  ; // no changes when j switches
   ?  *  b   ?   ?   1  0  ?  : ?  :  -  ; // no changes when k switches
   0  *  x   ?   1   1  0  ?  : 0  :  0  ; // no changes when k switches
   ?  ?  ?   ?   0   1  0  ?  : ?  :  1  ; // set output
   ?  ?  b   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  0  x   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  ?  ?   0   1   1  0  ?  : ?  :  0  ; // reset output
   ?  ?  b   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   0  ?  x   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?  ?  ?   ?   ?   0  0  ?  : ?  :  x  ; 
   ?  ?  ?   ?   ?   1  1  ?  : ?  :  x  ; 
   ?  ?  ?   ?   ?   0  1  ?  : ?  :  x  ; 
   ?  ?  ?   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier change

   endtable
endprimitive // udp_jkff


primitive udp_mux4 (out, in0, in1, in2, in3, sel_0, sel_1);
   output out;  
   input  in0, in1, in2, in3, sel_0, sel_1;

   table

// in0 in1 in2 in3 sel_0 sel_1 :  out
//
   0  ?  ?  ?  0  0  :  0;
   1  ?  ?  ?  0  0  :  1;
   ?  0  ?  ?  1  0  :  0;
   ?  1  ?  ?  1  0  :  1;
   ?  ?  0  ?  0  1  :  0;
   ?  ?  1  ?  0  1  :  1;
   ?  ?  ?  0  1  1  :  0;
   ?  ?  ?  1  1  1  :  1;
   0  0  ?  ?  x  0  :  0;
   1  1  ?  ?  x  0  :  1;
   ?  ?  0  0  x  1  :  0;
   ?  ?  1  1  x  1  :  1;
   0  ?  0  ?  0  x  :  0;
   1  ?  1  ?  0  x  :  1;
   ?  0  ?  0  1  x  :  0;
   ?  1  ?  1  1  x  :  1;
   1  1  1  1  x  x  :  1;
   0  0  0  0  x  x  :  0;

   endtable
endprimitive // udp_mux4


primitive udp_bmx (out, x2, a, s, m1, m0);
   output out;  
   input   x2, a, s, m1, m0;

   table
   //x2 a s m1 m0 : out
     0  ? 0 0  ?  : 1;   // PW a: 1->?
     0  1 ? 1  ?  : 0;   // PW s: 0->?
     0  ? 1 0  ?  : 0;   // PW a: 0->?
     0  0 ? 1  ?  : 1;   // PW s: 1->?
     1  ? 0 ?  0  : 1;   // PW a: 1->?
     1  1 ? ?  1  : 0;   // PW s: 0->?
     1  ? 1 ?  0  : 0;   // PW a: 0->?
     1  0 ? ?  1  : 1;   // PW s: 1->?
     ?  0 0 ?  ?  : 1;
     ?  1 1 ?  ?  : 0;
     ?  ? 1 0  0  : 0;
     ?  0 ? 1  1  : 1;
     ?  ? 0 0  0  : 1;
     ?  1 ? 1  1  : 0;


   endtable
endprimitive // udp_bmx


primitive udp_tlatrf (out, in, ww, wwn, NOTIFIER);
   output out;  
   input  in, ww, wwn, NOTIFIER;
   reg    out;

   table

// in  ww    wwn  NOT  : Qt : Qt+1
//	     
   1   ?     0    ?    : ?  :  1  ; // 
   1   1     ?    ?    : ?  :  1  ; // 
   0   ?     0    ?    : ?  :  0  ; // 
   0   1     ?    ?    : ?  :  0  ; // 
   1   *     ?    ?    : 1  :  1  ; // reduce pessimism
   1   ?     *    ?    : 1  :  1  ; // reduce pessimism
   0   *     ?    ?    : 0  :  0  ; // reduce pessimism
   0   ?     *    ?    : 0  :  0  ; // reduce pessimism
   *   0     1    ?    : ?  :  -  ; // no changes when in switches
   ?   ?     ?    *    : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlatrf

primitive udp_ph2p_pwr (LOUT, VDD, VSS, CLK1, CLK2, DATA1, DATA2, SET, RESET);
    output LOUT; reg LOUT;
    input VDD, VSS, CLK1, CLK2, DATA1, DATA2, SET, RESET;
    table
    //  **NOTE that for input combo's not given , the output will be x=unknown
    //  VDD VSS CLK1 CLK2 DATA1 DATA2 SET  RESET : state : LOUT
         1   0   ?    ?    ?     ?     0    0    :   ?   :  0 ;// Reset only on
         1   0   ?    ?    ?     ?     1    1    :   ?   :  1 ;// Set only on
         1   0   ?    ?    ?     ?     1    0    :   ?   :  1 ;// Both S/R active
         1   0   ?    ?    ?     ?     1    X    :   ?   :  1 ;// Set on, reset X
         1   0   0    0    ?     ?     0    1    :   ?   :  - ;// No Change
         1   0   1    0    0     ?     0    ?    :   ?   :  0 ;// First Port Function
         1   0   1    0    1     ?     ?    1    :   ?   :  1 ;
         1   0   0    1    ?     0     0    ?    :   ?   :  0 ;// Second Port Function
         1   0   0    1    ?     1     ?    1    :   ?   :  1 ;
         1   0   1    1    0     0     0    ?    :   ?   :  0 ;// Both Clocks ON
         1   0   1    1    1     1     ?    1    :   ?   :  1 ;
         1   0   ?    0    0     ?     0    1    :   0   :  - ;// Clocks Unknown
         1   0   ?    0    1     ?     0    1    :   1   :  - ;
         1   0   ?    1    0     0     0    ?    :   ?   :  0 ;
         1   0   ?    1    1     1     ?    1    :   ?   :  1 ;
         1   0   0    ?    ?     0     0    1    :   0   :  - ;
         1   0   0    ?    ?     1     0    1    :   1   :  - ;
         1   0   1    ?    0     0     0    ?    :   ?   :  0 ;
         1   0   1    ?    1     1     ?    1    :   ?   :  1 ;
         1   0   ?    ?    0     0     0    1    :   0   :  - ;
         1   0   ?    ?    1     1     0    1    :   1   :  - ;
         1   0   0    0    ?     ?     0    X    :   0   :  - ;// Reset Unknown
         1   0   ?    ?    0     0     0    X    :   0   :  - ;
         1   0   ?    0    0     ?     0    X    :   0   :  - ;
         1   0   0    ?    ?     0     0    X    :   0   :  - ;
         1   0   0    0    ?     ?     X    1    :   1   :  - ;// Set Unknown
         1   0   ?    ?    1     1     X    1    :   1   :  - ;
         1   0   ?    0    1     ?     X    1    :   1   :  - ;
         1   0   0    ?    ?     1     X    1    :   1   :  - ;
	 0   ?   ?    ?    ?     ?     ?    ?    :   ?   :  x ;  
	 ?   1   ?    ?    ?     ?     ?    ?    :   ?   :  x ;  
    endtable
endprimitive



primitive udp_tlat (out, in, hold, clr_, set_, NOTIFIER);
   output out;  
   input  in, hold, clr_, set_, NOTIFIER;
   reg    out;

   table

// in  hold  clr_   set_  NOT  : Qt : Qt+1
//
   1  0   1   ?   ?   : ?  :  1  ; // 
   0  0   ?   1   ?   : ?  :  0  ; // 
   1  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   *  1   ?   ?   ?   : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   ?   : ?  :  1  ; // set output
   ?  1   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   1  ?   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   ?   : ?  :  0  ; // reset output
   ?  1   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  ?   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat


primitive udp_tlat2n_pwr (out, VDD, VSS, in, hold, clr_, set_, NOTIFIER, NOTIFYRETN);
   output out;  
   input  VDD, VSS, in, hold, clr_, set_, NOTIFIER, NOTIFYRETN;
   reg    out;

   table

// VDD, VSS, in  hold  clr_   set_  NOT  NOT2: Qt : Qt+1
//
    1    0    1   0     1      ?     ?    ?  : ?  :  1  ; // 
    1    0    0   0     ?      1     ?    ?  : ?  :  0  ; // 
    1    0    1   *     1      ?     ?    ?  : 1  :  1  ; // reduce pessimism
    1    0    0   *     ?      1     ?    ?  : 0  :  0  ; // reduce pessimism
    1    0    *   1     ?      ?     ?    ?  : ?  :  -  ; // no changes when in switches
    1    0    ?   ?     ?      0     ?    ?  : ?  :  1  ; // set output
    1    0    ?   1     1      *     ?    ?  : 1  :  1  ; // cover all transistions on set_
    1    0    1   ?     1      *     ?    ?  : 1  :  1  ; // cover all transistions on set_
    1    0    ?   ?     0      1     ?    ?  : ?  :  0  ; // reset output
    1    0    ?   1     *      1     ?    ?  : 0  :  0  ; // cover all transistions on clr_
    1    0    0   ?     *      1     ?    ?  : 0  :  0  ; // cover all transistions on clr_
    0    ?    ?   ?     ?      ?     ?    ?  : ?  :  x  ;
    x    ?    ?   ?     ?      ?     ?    ?  : ?  :  x  ;
    ?    1    ?   ?     ?      ?     ?    ?  : ?  :  x  ;
    ?    x    ?   ?     ?      ?     ?    ?  : ?  :  x  ;
    ?    ?    ?   ?     ?      ?     *    ?  : ?  :  x  ; // any notifier changed
    ?    ?    ?   ?     ?      ?     ?    *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat2n


primitive udp_edfft (out, in, clk, clr_, set_, en, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, en, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  en  NOT  : Qt : Qt+1
//
   ?   r    0      1     ?   ?    : ?  :  0  ; // clock in 0
   0   r    ?      1     1   ?    : ?  :  0  ; // clock in 0
   ?   r    ?      0     ?   ?    : ?  :  1  ; // clock in 1
   1   r    1      ?     1   ?    : ?  :  1  ; // clock in 1
   ?   *    1      1     0   ?    : ?  :  -  ; // no changes, not enabled
   ?   *    ?      1     0   ?    : 0  :  0  ; // no changes, not enabled
   ?   *    1      ?     0   ?    : 1  :  1  ; // no changes, not enabled
   ?  (x0)  ?      ?     ?   ?    : ?  :  -  ; // no changes
   ?  (x1)  ?      0     ?   ?    : 1  :  1  ; // no changes
   1   *    1      ?     ?   ?    : 1  :  1  ; // reduce pessimism
   0   *    ?      1     ?   ?    : 0  :  0  ; // reduce pessimism
   ?   f    ?      ?     ?   ?    : ?  :  -  ; // no changes on negedge clk
   *   b    ?      ?     ?   ?    : ?  :  -  ; // no changes when in switches
   1   x    1      ?     ?   ?    : 1  :  1  ; // no changes when in switches
   ?   x    1      ?     0   ?    : 1  :  1  ; // no changes when in switches
   0   x    ?      1     ?   ?    : 0  :  0  ; // no changes when in switches
   ?   x    ?      1     0   ?    : 0  :  0  ; // no changes when in switches
   ?   b    ?      ?     *   ?    : ?  :  -  ; // no changes when en switches
   ?   b    *      ?     ?   ?    : ?  :  -  ; // no changes when clr_ switches
   ?   x    0      1     ?   ?    : 0  :  0  ; // no changes when clr_ switches
   ?   b    ?      *     ?   ?    : ?  :  -  ; // no changes when set_ switches
   ?   x    ?      0     ?   ?    : 1  :  1  ; // no changes when set_ switches
   ?   ?    ?      ?     ?   *    : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_edfft

primitive udp_xprop (DOUT, DIN, NOTIFIER, RESET);
    output DOUT; reg DOUT;
    input  DIN;
    input  NOTIFIER;
    input  RESET;
    table
    //  DIN  NOTIFIER  RESET : state :DOUT
         ?      *        ?   :   ?   :  x ;  // Timing violation -- takes precendence
         0      ?      (?1)  :   ?   :  0 ;  // Reset
         1      ?      (?1)  :   ?   :  1 ;
         0      ?      (0?)  :   0   :  0 ;  // Reset  Lena updated-----
         1      ?      (0?)  :   1   :  1 ;  // Lena updated---------
         0      ?      (1?)  :   0   :  0 ;  // Lena added-----------
         1      ?      (1?)  :   1   :  1 ;  // Lena added-----------
         0      ?      (?0)  :   ?   :  0 ; 
         1      ?      (?0)  :   ?   :  1 ;  
        (?1)    ?        ?   :   ?   :  1 ;
        (?0)    ?        ?   :   ?   :  0 ;
    // *****
    endtable
endprimitive



primitive udp_tlatrf_PWR (out, in, ww, wwn, VDD, VSS, NOTIFIER);
   output out;  
   input  in, ww, wwn, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  ww    wwn  VDD  VSS  NOTIFIER  : Qt : Qt+1
//	     
   1   ?     0    1  0  ?  : ?  :  1  ; // 
   1   1     ?    1  0  ?  : ?  :  1  ; // 
   0   ?     0    1  0  ?  : ?  :  0  ; // 
   0   1     ?    1  0  ?  : ?  :  0  ; // 
   1   *     ?    1  0  ?  : 1  :  1  ; // reduce pessimism
   1   ?     *    1  0  ?  : 1  :  1  ; // reduce pessimism
   0   *     ?    1  0  ?  : 0  :  0  ; // reduce pessimism
   0   ?     *    1  0  ?  : 0  :  0  ; // reduce pessimism
   *   0     1    1  0  ?  : ?  :  -  ; // no changes when in switches
   ?   ?     ?    0  0  ?  : ?  :  x  ; 
   ?   ?     ?    1  1  ?  : ?  :  x  ; 
   ?   ?     ?    0  1  ?  : ?  :  x  ; 
   ?   ?     ?    ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlatrf



primitive udp_sedfft_PWR (out, in, clk, clr_, si, se, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, si, se,  en, VDD, VSS, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  si  se  en  VDD  VSS  NOTIFIER : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   0  0  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   1  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   0  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   ?  ?  *  : ?  :  x; // any notifier changed
      ?    r    ?     0   1   ?   1  0  ?  : ?  :  0;     
      ?    r    ?     1   1   ?   1  0  ?  : ?  :  1;
      ?    b    ?     ?   *   ?   1  0  ?  : ?  :  -; // no changes when se switches
      ?    b    ?     *   ?   ?   1  0  ?  : ?  :  -; // no changes when si switches
      *    b    ?     ?   ?   ?   1  0  ?  : ?  :  -; // no changes when in switches
      ?    b    ?     ?   ?   *   1  0  ?  : ?  :  -; // no changes when en switches
      ?    b    *     ?   ?   ?   1  0  ?  : ?  :  -; // no changes when clr switches
      0    r    ?     0   ?   1   1  0  ?  : ?  :  0 ; 
      1    r    1     1   ?   1   1  0  ?  : ?  :  1 ; 
      ?    r    ?     0   ?   0   1  0  ?  : 0  :  0;
      ?    x    ?     0   ?   0   1  0  ?  : 0  :  0;
      ?    r    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    x    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    *    1     ?   0   0   1  0  ?  : ?  :  -;
      ?    *    ?     1   1   ?   1  0  ?  : 1  :  1;
      1    *    1     1   ?   ?   1  0  ?  : 1  :  1;
      ?    *    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    *    0     0   ?   ?   1  0  ?  : 0  :  0;
      0    *    ?     0   ?   ?   1  0  ?  : 0  :  0;
      ?    x    1     ?   0   0   1  0  ?  : ?  :  -;
      ?    *    ?     ?   0   0   1  0  ?  : 0  :  0;
      ?    x    ?     ?   0   0   1  0  ?  : 0  :  0;
      ?    x    ?     1   1   ?   1  0  ?  : 1  :  1;
      1    x    1     1   ?   ?   1  0  ?  : 1  :  1;
      ?    x    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    x    0     0   ?   ?   1  0  ?  : 0  :  0;
      0    x    ?     0   ?   ?   1  0  ?  : 0  :  0;
      ?    r    0     0   ?   ?   1  0  ?  : ?  :  0 ; 
      ?   (?0)  ?     ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   0   1   1  0  ?  : ?  :  1;
      0    r    ?     ?   0   1   1  0  ?  : ?  :  0;
      ?    r    0     ?   0   ?   1  0  ?  : ?  :  0;
      ?    x    0     ?   0   ?   1  0  ?  : 0  :  0;
      1    x    1     ?   0   ?   1  0  ?  : 1  :  1; // no changes when in switches
      0    x    ?     ?   0   ?   1  0  ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   0   ?   1  0  ?  : 1  :  1; // reduce pessimism
      0    *    ?     ?   0   ?   1  0  ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive  /* udp_sedfft */
   


primitive udp_tlat2n (out, in, hold, clr_, set_, NOTIFIER, NOTIFYRETN);
   output out;  
   input  in, hold, clr_, set_, NOTIFIER, NOTIFYRETN;
   reg    out;

   table

// in  hold  clr_   set_  NOT NOT2 : Qt : Qt+1
//
    1   0     1      ?     ?   ?   : ?  :  1  ; // 
    0   0     ?      1     ?   ?   : ?  :  0  ; // 
    1   *     1      ?     ?   ?   : 1  :  1  ; // reduce pessimism
    0   *     ?      1     ?   ?   : 0  :  0  ; // reduce pessimism
    *   1     ?      ?     ?   ?   : ?  :  -  ; // no changes when in switches
    ?   ?     ?      0     ?   ?   : ?  :  1  ; // set output
    ?   1     1      *     ?   ?   : 1  :  1  ; // cover all transistions on set_
    1   ?     1      *     ?   ?   : 1  :  1  ; // cover all transistions on set_
    ?   ?     0      1     ?   ?   : ?  :  0  ; // reset output
    ?   1     *      1     ?   ?   : 0  :  0  ; // cover all transistions on clr_
    0   ?     *      1     ?   ?   : 0  :  0  ; // cover all transistions on clr_
    ?   ?     ?      ?     *   ?   : ?  :  x  ; // any notifier changed
    ?   ?     ?      ?     ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat


primitive udp_rslatn_pwr (outn, r, s, VDD, VSS, NOTIFIER);
   output outn;  
   input  r, s, VDD, VSS, NOTIFIER;
   reg    outn;

   table

// r   s   VDD  VSS  NOTIFIER : Qtn : Qtn+1
// 
  (?0) 0   1  0  ?  : ?  :  -  ; // no change
   0  (?0) 1  0  ?  : ?  :  -  ; // no change
   1   0   1  0  ?  : ?  :  1  ; // reset
   b   1   1  0  ?  : ?  :  0  ; // set
  (?0) x   1  0  ?  : 0  :  0  ; // reduced pessimism
   0  (?x) 1  0  ?  : 0  :  0  ; // reduced pessimism
  (?x) 0   1  0  ?  : 1  :  1  ; // reduced pessimism
   x  (?0) 1  0  ?  : 1  :  1  ; // reduced pessimism
   ?   ?   0  ?  ?  : ?  :  x  ; 
   ?   ?   ?  1  ?  : ?  :  x  ; 
   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out


primitive udp_rslat_pwr (out, r, s, VDD, VSS, NOTIFIER);
   output out;  
   input  r, s, VDD, VSS, NOTIFIER;
   reg    out;

   table

// r   s   VDD  VSS  NOTIFIER : Qt : Qt+1
// 
  (?0) 0   1  0  ?  : ?  :  -  ; // no change
   0  (?0) 1  0  ?  : ?  :  -  ; // no change
   1   b   1  0  ?  : ?  :  0  ; // reset
   0   1   1  0  ?  : ?  :  1  ; // set
  (?0) x   1  0  ?  : 1  :  1  ; // reduced pessimism
   0  (?x) 1  0  ?  : 1  :  1  ; // reduced pessimism
  (?x) 0   1  0  ?  : 0  :  0  ; // reduced pessimism
   x  (?0) 1  0  ?  : 0  :  0  ; // reduced pessimism
   ?   ?   0  ?  ?  : ?  :  x  ; 
   ?   ?   ?  1  ?  : ?  :  x  ; 
   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out


primitive udp_rslatn (outn, r, s, NOTIFIER);
   output outn;  
   input  r, s, NOTIFIER;
   reg    outn;

   table

// r   s   NOTIFIER : Qtn : Qtn+1
// 
  (?0) 0   ?  : ?  :  -  ; // no change
   0  (?0) ?  : ?  :  -  ; // no change
   1   0   ?  : ?  :  1  ; // reset
   b   1   ?  : ?  :  0  ; // set
  (?0) x   ?  : 0  :  0  ; // reduced pessimism
   0  (?x) ?  : 0  :  0  ; // reduced pessimism
  (?x) 0   ?  : 1  :  1  ; // reduced pessimism
   x  (?0) ?  : 1  :  1  ; // reduced pessimism
   ?   ?   *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out


primitive udp_rslat (out, r, s, NOTIFIER);
   output out;  
   input  r, s, NOTIFIER;
   reg    out;

   table

// r   s   NOTIFIER : Qt : Qt+1
// 
  (?0) 0   ?  : ?  :  -  ; // no change
   0  (?0) ?  : ?  :  -  ; // no change
   1   b   ?  : ?  :  0  ; // reset
   0   1   ?  : ?  :  1  ; // set
  (?0) x   ?  : 1  :  1  ; // reduced pessimism
   0  (?x) ?  : 1  :  1  ; // reduced pessimism
  (?x) 0   ?  : 0  :  0  ; // reduced pessimism
   x  (?0) ?  : 0  :  0  ; // reduced pessimism
   ?   ?   *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out
