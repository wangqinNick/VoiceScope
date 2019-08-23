`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// National University of Singapore
// Department of Electrical and Computer Engineering
// EE2026 Digital Design
// AY1819 Semester 1
// Project: Voice Scope
//////////////////////////////////////////////////////////////////////////////////

module Voice_Scope_TOP(
    input CLK,
    input sw0,sw1,sw2,sw15,sw14,sw13,sw12,sw11,sw10, sw9,sw8,sw7,sw6,sw5,sw4,sw3, 
    input btnU, btnD,btnC,btnL,btnR,
    
    input  J_MIC3_Pin3,   // PmodMIC3 audio input data (serial)
    output J_MIC3_Pin1,   // PmodMIC3 chip select, 20kHz sampling clock
    output J_MIC3_Pin4,   // PmodMIC3 serial clock (generated by module VoiceCapturer.v)
    
    //output J_DA2_Pin1,    // PmodDA2 sampling clock (generated by module DA2RefComp.vhd)
    //output J_DA2_Pin2,    // PmodDA2 Data_A, 12-bit speaker output (generated by module DA2RefComp.vhd)
    //output J_DA2_Pin3,    // PmodDA2 Data_B, not used (generated by module DA2RefComp.vhd)
    //output J_DA2_Pin4,    // PmodDA2 serial clock, 50MHz clock
    
    output [3:0] vgaRed,    // RGB outputs to VGA connector (4 bits per channel gives 4096 possible colors)
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    
    output VGA_VS,          // horizontal & vertical sync outputs to VGA connector
    output VGA_HS,
    output [13:0]led,
    output [3:0] an,
    output [7:0] seg
    );
    
    
// Please create a clock divider module to generate 20kHz and 10Hz clock signals. 
// Instantiate it below
    wire clk_20k;
    wire clk_1Hz;
    wire clk_10Hz;
    wire clk_8Hz;
    wire clk_640Hz;
    wire clk_128Hz;
    wire clk_762Hz;
    wire clk_2Hz;
    wire clk_20Hz;
    wire clk_3Hz;
    wire clk_30Hz;
    //clk_div module1;
    clk_divider clock_divider_1 (CLK, 20000, clk_20k);
    clk_divider clock_divider_2 (CLK, 10, clk_10Hz);
    clk_divider clock_divider_3 (CLK, 8, clk_8Hz);
    clk_divider clock_divider_4 (CLK, 640, clk_640Hz);
    clk_divider clock_divider_5 (CLK, 128, clk_128Hz);
    clk_divider clock_divider_6 (CLK, 762, clk_762Hz);
    clk_divider clock_divider_7 (CLK, 1, clk_1Hz);
    clk_divider clock_divider_8 (CLK, 2, clk_2Hz);
    clk_divider clock_divider_9 (CLK, 20, clk_20Hz);
    clk_divider clock_divider_10 (CLK, 3, clk_3Hz);
    clk_divider clock_divider_11 (CLK, 30, clk_30Hz);
    
// Please instantiate the voice capturer module below
    wire [11:0] MIC_in;//6
    VOICE_CAPTURER voice_capture (CLK, clk_20k, J_MIC3_Pin3, J_MIC3_Pin1, J_MIC3_Pin4, MIC_in);
    
    
// Please instantiate the waveform drawer module below
    wire [11:0] VGA_HORZ_COORD;
    wire [11:0] VGA_VERT_COORD; 
    
    wire [3:0] R_wave;wire [3:0] R_wave_2;wire [3:0] R_wave_3;wire [3:0] R_wave_4;
    wire [3:0] G_wave;wire [3:0] G_wave_2;wire [3:0] G_wave_3;wire [3:0] G_wave_4;
    wire [3:0] B_wave;wire [3:0] B_wave_2;wire [3:0] B_wave_3;wire [3:0] B_wave_4;
    
    wire [3:0] R_wave_A;wire [3:0] R_wave_B;wire [3:0] R_wave_C;wire [3:0] R_wave_D;wire [3:0] R_grid_a;
    wire [3:0] G_wave_A;wire [3:0] G_wave_B;wire [3:0] G_wave_C;wire [3:0] G_wave_D;wire [3:0] G_grid_a;
    wire [3:0] B_wave_A;wire [3:0] B_wave_B;wire [3:0] B_wave_C;wire [3:0] B_wave_D;wire [3:0] B_grid_a;
    
    wire clk_sample;
    wire clk_display;
    wire [11:2] wave_sample;//1
    wire [11:2] test_wave_sample;//2
    TestWave_Gen testwave (clk_20k, test_wave_sample); //TestWaveForm
    
    //mulx
    assign wave_sample = (sw0 == 0) ? test_wave_sample : MIC_in[11:2];
        wire [11:0] max_in;
    volume_indicator vol_f (MIC_in,clk_20k, clk_10Hz, clk_762Hz,sw2, led, an, seg, max_in);
    
    draw_character draw_character (.VGA_HORZ_COORD (VGA_HORZ_COORD)
                                    ,.VGA_VERT_COORD (VGA_VERT_COORD)
                                    , .max_in (max_in)
                                   ,.VGA_Red_Grid (R_grid_a)
                                   ,.VGA_Green_Grid (G_grid_a)
                                   ,.VGA_Blue_Grid (B_grid_a)
                                    ,.clk_1Hz (clk_1Hz)
                                    );
                                    
    wire [3:0] br;
    wire [3:0] bg;
    wire [3:0] bb;
    background_select background_select_1 (clk_2Hz, sw6, br, bg, bb);
    wire [3:0] wr;
    wire [3:0] wg;
    wire [3:0] wb;
    wave_color_select wave_color_select_1 (clk_2Hz, sw3, wr, wg, wb);
//    wire [3:0] br_B;
//    wire [3:0] bg_B;
//    wire [3:0] bb_B;
//    background_select background_select_B (clk_2Hz, sw6, br_B, bg_B, bb_B);
//    wire [3:0] br_C;
//    wire [3:0] bg_C;
//    wire [3:0] bb_C;
//    background_select background_select_C (clk_2Hz, sw6, br_C, bg_C, bb_C);
//    wire [3:0] br_D;
//    wire [3:0] bg_D;
//    wire [3:0] bb_D;
//    background_select background_select_D (clk_2Hz, sw6, br_D, bg_D, bb_D);   
             
    //for test only
    //assign led = wave_sample;
    Draw_Waveform draw_wave (.sw4(sw4),.br(br), .bg(bg), .bb( bb),.wave_sample(wave_sample),.sw8(sw3),.clk(CLK),.clk_sample(clk_20k),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave),.VGA_Green_waveform(G_wave),.VGA_Blue_waveform(B_wave));
    Draw_Waveform_2 draw_wave_2 (.max_in(max_in),.clk_30Hz(clk_30Hz),.clk_2Hz (clk_2Hz),.clk_3Hz(clk_3Hz),.mic_in (MIC_in),.wr(wr), .wg(wg), .wb( wb), .br(br), .bg(bg), .bb( bb),.wave_sample(wave_sample),.clk_sample(clk_20k),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave_2),.VGA_Green_waveform(G_wave_2),.VGA_Blue_waveform(B_wave_2));
    Draw_Waveform_3 draw_wave_3 (.wave_sample(wave_sample),.clk_8Hz(clk_8Hz),.max_in(max_in),.clk_sample(clk_20k),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave_3),.VGA_Green_waveform(G_wave_3),.VGA_Blue_waveform(B_wave_3));
    Draw_Waveform_4 draw_wave_4 (.wave_sample(wave_sample),.sw(sw1),.clk_sample(clk_20k),.clk_640Hz(clk_640Hz),.clk_128Hz(clk_128Hz),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave_4),.VGA_Green_waveform(G_wave_4),.VGA_Blue_waveform(B_wave_4));
                             
    Draw_Waveform_A draw_wave_A (.sw4(sw4),.br(br), .bg(bg), .bb( bb),.wave_sample(wave_sample),.sw8(sw3),.clk(CLK),.clk_sample(clk_20k),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave_A),.VGA_Green_waveform(G_wave_A),.VGA_Blue_waveform(B_wave_A));
    Draw_Waveform_E draw_wave_E (.sw9(sw9),.sw8(sw8),.max_in(max_in),.clk_30Hz(clk_30Hz),.clk_2Hz (clk_2Hz),.clk_3Hz(clk_3Hz),.mic_in (MIC_in),.wr(wr), .wg(wg), .wb( wb), .br(br), .bg(bg), .bb( bb),.wave_sample(wave_sample),.clk_sample(clk_20k),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave_B),.VGA_Green_waveform(G_wave_B),.VGA_Blue_waveform(B_wave_B));
    Draw_Waveform_C draw_wave_C (.br(br), .bg(bg), .bb( bb), .wave_sample(wave_sample),.max_in(max_in),.clk_sample(clk_20k),.clk_8Hz(clk_8Hz),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave_C),.VGA_Green_waveform(G_wave_C),.VGA_Blue_waveform(B_wave_C));
    Draw_Waveform_D draw_wave_D (.br(br), .bg(bg), .bb( bb), .wave_sample(wave_sample),.sw(sw1),.clk_sample(clk_20k),.clk_640Hz(clk_640Hz),.clk_128Hz(clk_128Hz),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_wave_D),.VGA_Green_waveform(G_wave_D),.VGA_Blue_waveform(B_wave_D));
    
    wire [3:0] R_pic; wire [3:0] G_pic; wire [3:0] B_pic;
    draw_pic draw_pic (.clk(CLK), .clk_sample(clk_20k) ,.VGA_HORZ_COORD(VGA_HORZ_COORD) ,.VGA_VERT_COORD(VGA_VERT_COORD) ,.VGA_Red_waveform(R_pic) ,.VGA_Green_waveform(G_pic) ,.VGA_Blue_waveform(B_pic));
    
    wire [3:0] R_freeze; wire [3:0] G_freeze; wire [3:0] B_freeze;
    draw_freeze_waveform(.br(br), .bg(bg), .bb( bb),.clk_20Hz(clk_20Hz),.clk_sample(clk_20k),.clk(CLK),.sw4(sw4),.wave_sample(wave_sample),.VGA_HORZ_COORD(VGA_HORZ_COORD) ,.VGA_VERT_COORD(VGA_VERT_COORD),.VGA_Red_waveform(R_freeze) ,.VGA_Green_waveform(G_freeze) ,.VGA_Blue_waveform(B_freeze));
// Please instantiate the background drawing module below   
    wire [3:0] R_grid;wire [3:0] R_grid1;
    wire [3:0] G_grid;wire [3:0] G_grid1;
    wire [3:0] B_grid;wire [3:0] B_grid1;
    wire [3:0] gr;
    wire [3:0] gg;
    wire [3:0] gb;
    grid_select grid_select_1 (clk_2Hz, sw5, gr, gg, gb);
    Draw_Background draw_grid (.gr(gr),.gg(gg),.gb(gb),.clk(CLK),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.sw15(sw15),.sw14(sw14),.sw13(sw13),.sw12(sw12),.sw11(sw11),.sw10(sw10)
                                ,.VGA_Red_Grid(R_grid),.VGA_Green_Grid(G_grid),.VGA_Blue_Grid(B_grid));
                                
    Draw_Background1 draw_grid1 (.clk(CLK),.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD),.sw15(sw15),.sw14(sw14),.sw13(sw13),.sw12(sw12),.sw11(sw11),.sw10(sw10)
                                 ,.VGA_Red_Grid(R_grid1),.VGA_Green_Grid(G_grid1),.VGA_Blue_Grid(B_grid1));                            
    
    wire [3:0] R_grid_select;
    wire [3:0] G_grid_select;
    wire [3:0] B_grid_select;
 
    reg [10:0] count = 0;
    reg screen_protector = 0; //not screen protector
    always @ (posedge clk_10Hz) begin
        if(max_in < 2120) begin
            count = (count >= 150 ) ? 150 : count + 1;
        end
        else if (max_in > 2200) begin
            count <= 0;
        end
        if( count >= 150) begin
            screen_protector <= 1;
        end
        else begin
            screen_protector <= 0;
        end
    end
    
    Draw_Grid_Select draw_grid_select(CLK,btnU,btnD,btnC,btnL,btnR,VGA_HORZ_COORD,VGA_VERT_COORD,R_grid_select,G_grid_select,B_grid_select);
// Please instantiate the VGA display module below     
    VGA_DISPLAY display (.CLK(CLK),.sw4(sw4),.sw8(sw8),.screen_protector(screen_protector),.btnU(btnU),.btnD(btnD),.btnC(btnC),.btnL(btnL),.btnR(btnR)
                        ,.VGA_RED_WAVEFORM(R_wave),.VGA_GREEN_WAVEFORM(G_wave),.VGA_BLUE_WAVEFORM(B_wave)
                        ,.VGA_RED_GRID_a(R_grid_a),.VGA_GREEN_GRID_a(G_grid_a),.VGA_BLUE_GRID_a(B_grid_a)
                        ,.VGA_RED_WAVEFORM_2(R_wave_2),.VGA_GREEN_WAVEFORM_2(G_wave_2),.VGA_BLUE_WAVEFORM_2(B_wave_2)
                         ,.VGA_RED_WAVEFORM_3(R_wave_3),.VGA_GREEN_WAVEFORM_3(G_wave_3),.VGA_BLUE_WAVEFORM_3(B_wave_3)
                        ,.VGA_RED_WAVEFORM_4(R_wave_4),.VGA_GREEN_WAVEFORM_4(G_wave_4),.VGA_BLUE_WAVEFORM_4(B_wave_4)
                        ,.VGA_RED_WAVEFORM_A(R_wave_A),.VGA_GREEN_WAVEFORM_A(G_wave_A),.VGA_BLUE_WAVEFORM_A(B_wave_A)
                        ,.VGA_RED_WAVEFORM_B(R_wave_B),.VGA_GREEN_WAVEFORM_B(G_wave_B),.VGA_BLUE_WAVEFORM_B(B_wave_B)
                        ,.VGA_RED_WAVEFORM_C(R_wave_C),.VGA_GREEN_WAVEFORM_C(G_wave_C),.VGA_BLUE_WAVEFORM_C(B_wave_C)
                        ,.VGA_RED_WAVEFORM_D(R_wave_D),.VGA_GREEN_WAVEFORM_D(G_wave_D),.VGA_BLUE_WAVEFORM_D(B_wave_D)
                        ,.VGA_RED_WAVEFORM_Freeze(R_freeze),.VGA_GREEN_WAVEFORM_Freeze(G_freeze),.VGA_BLUE_WAVEFORM_Freeze(B_freeze)
                        ,.VGA_RED_GRID(R_grid),.VGA_GREEN_GRID(G_grid),.VGA_BLUE_GRID(B_grid)
                        ,.VGA_RED_GRID1(R_grid1),.VGA_GREEN_GRID1(G_grid1),.VGA_BLUE_GRID1(B_grid1)
                        ,.VGA_RED_GRID_SELECT(R_grid_select),.VGA_GREEN_GRID_SELECT(G_grid_select),.VGA_BLUE_GRID_SELECT(B_grid_select)
                        ,.VGA_HORZ_COORD(VGA_HORZ_COORD),.VGA_VERT_COORD(VGA_VERT_COORD)
                        ,.VGA_RED(vgaRed),.VGA_GREEN(vgaGreen),.VGA_BLUE(vgaBlue)
                        ,.VGA_VS(VGA_VS),.VGA_HS(VGA_HS)
                        ,.R_pic(R_pic),.G_pic(G_pic),.B_pic(B_pic));
                        
                    


                     
endmodule
