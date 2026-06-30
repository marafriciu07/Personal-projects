----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2026 23:13:39
-- Design Name: 
-- Module Name: top_vga - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_vga is
    Port ( cell_state: in std_logic_vector (3 downto 0);
           vertical_count : in STD_LOGIC_VECTOR (2 downto 0);
           pixel_row_out : out STD_LOGIC_VECTOR (7 downto 0));
end top_vga;

architecture Behavioral of top_vga is

component demultiplexer is
    Port ( sel_code : in STD_LOGIC_VECTOR (3 downto 0);
           cs_empty_nonOpen : out STD_LOGIC;
           cs_empty_open : out STD_LOGIC;
           cs_1 : out STD_LOGIC;
           cs_2 : out STD_LOGIC;
           cs_bomb : out STD_LOGIC;
           cs_3 : out STD_LOGIC;
           cs_4: out std_logic;
           cs_5 : out STD_LOGIC;
           cs_6: out std_logic;
           cs_7 : out STD_LOGIC;
           cs_8: out std_logic);
end component demultiplexer;

component ROM_Empty_NonOpen is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_Empty_NonOpen;

component ROM_Empty_Open is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_Empty_Open;

component ROM_one is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_one;

component ROM_Two is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_Two;

component ROM_Three is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_Three;

component ROM_Bomb is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_Bomb;

component ROM_FOUR is
 Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_FOUR;

component ROM_FIVE is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_FIVE;

component ROM_SIX is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_SIX;

component ROM_SEVEN is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_SEVEN;

component ROM_EIGHT is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end component ROM_EIGHT;

signal wire_cs_empty_nonopen: STD_LOGIC;
signal wire_cs_empty_open: STD_LOGIC;
signal wire_cs_bomb: STD_LOGIC;
signal wire_cs_1: STD_LOGIC;
signal wire_cs_2 : STD_LOGIC;
signal wire_cs_3 : STD_LOGIC;
signal wire_cs_4 : STD_LOGIC;
signal wire_cs_5: STD_LOGIC;
signal wire_cs_6 : STD_LOGIC;
signal wire_cs_7 : STD_LOGIC;
signal wire_cs_8 : STD_LOGIC;

signal wire_data1_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data2_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data3_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data4_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data5_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data6_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data7_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data8_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data_bomb_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data_empty_open_rom: STD_LOGIC_VECTOR(7 downto 0);
signal wire_data_empty_nonopen_rom: STD_LOGIC_VECTOR(7 downto 0);

begin

DEMULTIPLEXER_label: demultiplexer port map( sel_code => cell_state, cs_empty_nonOpen => wire_cs_empty_nonopen, cs_empty_open => wire_cs_empty_open,
                                            cs_bomb => wire_cs_bomb, cs_1 => wire_cs_1, cs_2 => wire_cs_2, cs_3 => wire_cs_3,
                                            cs_4 => wire_cs_4, cs_5 => wire_cs_5, cs_6 => wire_cs_6, cs_7 => wire_cs_7, cs_8=> wire_cs_8);
ROM_ONE_label: ROM_one port map( address => vertical_count, cs => wire_cs_1, data_out => wire_data1_rom);
ROM_TWO_label: ROM_Two port map( address => vertical_count, cs => wire_cs_2, data_out => wire_data2_rom);
ROM_THREE_label: ROM_Three port map ( address => vertical_count, cs => wire_cs_3, data_out => wire_data3_rom);
ROM_BOMB_label: ROM_Bomb port map ( address => vertical_count, cs => wire_cs_bomb, data_out => wire_data_bomb_rom);
ROM_EMPTY_OPEN_label: ROM_Empty_Open port map ( address => vertical_count, cs => wire_cs_empty_open, data_out => wire_data_empty_open_rom);
ROM_EMPTY_NONOPEN_label: ROM_Empty_NonOpen port map( address => vertical_count, cs => wire_cs_empty_nonopen, data_out => wire_data_empty_nonopen_rom);
ROM_FOUR_label : ROM_FOUR port map( address => vertical_count, cs => wire_cs_4, data_out => wire_data4_rom);
ROM_FIVE_label : ROM_FIVE port map( address => vertical_count, cs => wire_cs_5, data_out => wire_data5_rom);
ROM_SIX_label : ROM_SIX port map( address => vertical_count, cs => wire_cs_6, data_out => wire_data6_rom);
ROM_SEVEN_label : ROM_SEVEN port map( address => vertical_count, cs => wire_cs_7, data_out => wire_data7_rom);
ROM_EIGHT_label : ROM_EIGHT port map( address => vertical_count, cs => wire_cs_8, data_out => wire_data8_rom);

pixel_row_out <= wire_data1_rom when wire_cs_1 = '1' else
                 wire_data2_rom when wire_cs_2 = '1' else
                 wire_data3_rom when wire_cs_3 = '1' else
                 wire_data4_rom when wire_cs_4 = '1' else
                 wire_data5_rom when wire_cs_5 = '1' else
                 wire_data6_rom when wire_cs_6 = '1' else
                 wire_data7_rom when wire_cs_7 = '1' else
                 wire_data8_rom when wire_cs_8 = '1' else
                 wire_data_bomb_rom when wire_cs_bomb = '1' else
                 wire_data_empty_open_rom when wire_cs_empty_open = '1' else
                 wire_data_empty_nonopen_rom when wire_cs_empty_nonopen = '1' else
                 "00000000";
end Behavioral;
