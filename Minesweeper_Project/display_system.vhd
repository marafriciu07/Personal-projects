----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2026 16:08:27
-- Design Name: 
-- Module Name: display_system - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_system is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           --write side from UC
           we_ram : in STD_LOGIC;
           uc_address : in STD_LOGIC_VECTOR (5 downto 0);
           data_to_ram : in STD_LOGIC_VECTOR (3 downto 0);
           
            -- mouse position for cursor
           mouse_xpos : in STD_LOGIC_VECTOR(11 downto 0);
           mouse_ypos : in STD_LOGIC_VECTOR(11 downto 0);
           
           --VGA outputs
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           r : out STD_LOGIC_VECTOR (3 downto 0);
           g : out STD_LOGIC_VECTOR (3 downto 0);
           b : out STD_LOGIC_VECTOR (3 downto 0);
           
           --vga board
           game_over : in STD_LOGIC;
           game_won  : in STD_LOGIC);
end display_system;

architecture Behavioral of display_system is

component COUNTER_vga is
Port (  clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        pixel_bit   : in STD_LOGIC;
        mouse_xpos  : in STD_LOGIC_VECTOR(11 downto 0);
        mouse_ypos  : in STD_LOGIC_VECTOR(11 downto 0);

        r, g, b     : out STD_LOGIC_VECTOR (3 downto 0);
        vs, hs      : out STD_LOGIC;
        current_cell_x : out integer range 0 to 7;
        current_cell_y : out integer range 0 to 7;
        current_pixel_x : out integer range 0 to 7;
        current_pixel_y : out integer range 0 to 7;
        game_over : in STD_LOGIC;
        game_won  : in STD_LOGIC);
end component COUNTER_vga;

component top_vga is
    Port ( cell_state: in std_logic_vector (3 downto 0);
           vertical_count : in STD_LOGIC_VECTOR (2 downto 0);
           pixel_row_out : out STD_LOGIC_VECTOR (7 downto 0));
end component top_vga;

component RAM is
    Port ( address : in STD_LOGIC_VECTOR (5 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           we : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (3 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
end component RAM;

signal cell_x_sig : integer range 0 to 7;
signal cell_y_sig : integer range 0 to 7;
signal pixel_x_sig : integer range 0 to 7;
signal pixel_y_sig : integer range 0 to 7;

signal vga_address : std_logic_vector(5 downto 0);
signal ram_address : std_logic_vector(5 downto 0);
signal ram_data_out : std_logic_vector(3 downto 0);
signal pixel_bit_s : std_logic;
signal pixel_row_out_s : std_logic_vector (7 downto 0);

signal vertical_count_s : STD_LOGIC_VECTOR(2 downto 0);

begin
VGA_COUNTER_label: COUNTER_vga port map (clk => clk, rst => rst, pixel_bit => pixel_bit_s, r => r, g => g, b => b, vs => vs, hs =>hs, current_cell_x => cell_x_sig,
                                         current_cell_y => cell_y_sig, current_pixel_x => pixel_x_sig, current_pixel_y => pixel_y_sig, mouse_xpos => mouse_xpos,mouse_ypos => mouse_ypos,game_over => game_over,
                                         game_won  => game_won);
vga_address <= conv_std_logic_vector(cell_x_sig * 8 + cell_y_sig, 6);
vertical_count_s <= conv_std_logic_vector(pixel_x_sig, 3);
ram_address <= uc_address when we_ram = '1' else vga_address;

RAM_label : RAM port map( address => ram_address, clk => clk, reset => rst, we => we_ram, data_in => data_to_ram, data_out => ram_data_out);

TOP_VGA_label : top_vga port map( cell_state => ram_data_out, vertical_count => vertical_count_s, pixel_row_out => pixel_row_out_s);
    process(pixel_row_out_s, pixel_y_sig)
    begin
        case pixel_y_sig is
            when 0 => pixel_bit_s <= pixel_row_out_s(7);
            when 1 => pixel_bit_s <= pixel_row_out_s(6);
            when 2 => pixel_bit_s <= pixel_row_out_s(5);
            when 3 => pixel_bit_s <= pixel_row_out_s(4);
            when 4 => pixel_bit_s <= pixel_row_out_s(3);
            when 5 => pixel_bit_s <= pixel_row_out_s(2);
            when 6 => pixel_bit_s <= pixel_row_out_s(1);
            when others => pixel_bit_s <= pixel_row_out_s(0);
        end case;
    end process;
    
end Behavioral;
