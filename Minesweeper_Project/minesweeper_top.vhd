----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2026 10:43:21
-- Design Name: 
-- Module Name: minesweeper_top - Behavioral
-- Project Name: MINESWEEPER
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

entity minesweeper_top is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           seed : in STD_LOGIC_VECTOR (5 downto 0);
           
           ps2_clk : inout STD_LOGIC;
           ps2_data : inout STD_LOGIC;
           
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           r : out STD_LOGIC_VECTOR (3 downto 0);
           led_click : out STD_LOGIC;
           led_write : out STD_LOGIC;
           g : out STD_LOGIC_VECTOR (3 downto 0);
           b : out STD_LOGIC_VECTOR (3 downto 0));
end minesweeper_top;

architecture Behavioral of minesweeper_top is

component top1 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           mouse_click : in STD_LOGIC;
           mouse_x : in STD_LOGIC_VECTOR (2 downto 0);
           mouse_y : in STD_LOGIC_VECTOR (2 downto 0);
           seed : in STD_LOGIC_VECTOR (5 downto 0);
           address_bus : out STD_LOGIC_VECTOR (5 downto 0);
           we_ram      : out STD_LOGIC;
           data_to_ram : out STD_LOGIC_VECTOR (3 downto 0);
           game_over_out : out STD_LOGIC;
           game_won_out  : out STD_LOGIC);
end component top1;

component display_system is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           --write side from UC
           we_ram : in STD_LOGIC;
           uc_address : in STD_LOGIC_VECTOR (5 downto 0);
           data_to_ram : in STD_LOGIC_VECTOR (3 downto 0);
           
           --mouse
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
end component display_system;

component mouse_to_board is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ps2_clk : inout STD_LOGIC;
           ps2_data : inout STD_LOGIC;
           mouse_click : out STD_LOGIC;
           mouse_x : out STD_LOGIC_VECTOR (2 downto 0);
           mouse_y : out STD_LOGIC_VECTOR (2 downto 0);
           mouse_xpos  : out STD_LOGIC_VECTOR(11 downto 0);
           mouse_ypos  : out STD_LOGIC_VECTOR(11 downto 0));
end component mouse_to_board;

signal mouse_click_sig : std_logic;
signal mouse_x_sig : std_logic_vector (2 downto 0);
signal mouse_y_sig : std_logic_vector (2 downto 0);

signal mouse_xpos_sig  : STD_LOGIC_VECTOR(11 downto 0);
signal mouse_ypos_sig  : STD_LOGIC_VECTOR(11 downto 0);

signal address_bus_sig : STD_LOGIC_VECTOR (5 downto 0);
signal we_ram_sig      : STD_LOGIC;
signal data_to_ram_sig : STD_LOGIC_VECTOR (3 downto 0);

signal clicked_led : STD_LOGIC := '0';
signal write_led : STD_LOGIC := '0';

signal game_over_sig : STD_LOGIC;
signal game_won_sig  : STD_LOGIC;

begin

MOUSE_TO_BOARD_label: mouse_to_board port map (clk => clk, rst => rst, ps2_clk => ps2_clk, ps2_data => ps2_data,
                                               mouse_click => mouse_click_sig, mouse_x => mouse_x_sig, mouse_y => mouse_y_sig,  mouse_xpos  => mouse_xpos_sig, mouse_ypos  => mouse_ypos_sig);
UC_TOP_label: top1 port map (clk => clk, reset => rst, seed => seed, mouse_click => mouse_click_sig, mouse_x => mouse_x_sig, mouse_y => mouse_y_sig,  address_bus => address_bus_sig,
                             we_ram  => we_ram_sig,data_to_ram => data_to_ram_sig, game_over_out => game_over_sig, game_won_out  => game_won_sig);                                            
DISPLAY_label : display_system port map (clk => clk, rst => rst, we_ram => we_ram_sig, uc_address => address_bus_sig, data_to_ram => data_to_ram_sig,
                                         hs => hs, vs => vs, r => r, g => g, b => b, mouse_xpos  => mouse_xpos_sig, mouse_ypos  => mouse_ypos_sig, game_over => game_over_sig, game_won  => game_won_sig);
process(clk, rst)
begin
    if rst = '1' then
        clicked_led <= '0';
    elsif rising_edge(clk) then
        if mouse_click_sig = '1' then
            clicked_led <= '1';
        end if;
    end if;
end process;

led_click <= clicked_led;

process(clk, rst)
begin
    if rst = '1' then
        write_led <= '0';
    elsif rising_edge(clk) then
        if we_ram_sig = '1' then
            write_led <= '1';
        end if;
    end if;
end process;

led_write <= write_led;
end Behavioral;
