----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2026 13:20:15
-- Design Name: 
-- Module Name: top1 - Behavioral
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

package bombs_integer is
    type bomb_array is array (0 to 63) of integer range 0 to 9;
end package bombs_integer;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.bombs_integer.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top1 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           mouse_click : in STD_LOGIC;
           mouse_x : in STD_LOGIC_VECTOR (2 downto 0);
           mouse_y : in STD_LOGIC_VECTOR (2 downto 0);
           seed : in STD_LOGIC_VECTOR (5 downto 0);
           
           address_bus : out STD_LOGIC_VECTOR (5 downto 0);
           we_ram      : out STD_LOGIC;
           
           game_over_out : out STD_LOGIC;
           game_won_out  : out STD_LOGIC;
           data_to_ram : out STD_LOGIC_VECTOR (3 downto 0));
end top1;

architecture Behavioral of top1 is

component BOMB_POSITIONS is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           seed : in STD_LOGIC_VECTOR (5 downto 0);
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           bombs_flat : out STD_LOGIC_VECTOR (63 downto 0);
           done : out STD_LOGIC);
end component BOMB_POSITIONS;

component Minesweeper_game_map is
    Port ( start : in STD_LOGIC;
           clk : in STD_LOGIC;
           bombs_flat : in STD_LOGIC_VECTOR (63 downto 0);
           map_mines: out bomb_array := (others => 0));
end component Minesweeper_game_map;

component UC is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           mouse_click : in STD_LOGIC;
           mouse_x : in STD_LOGIC_VECTOR (2 downto 0);
           mouse_y : in STD_LOGIC_VECTOR (2 downto 0);
           map_mines: in bomb_array;
           output_stack: in STD_LOGIC_VECTOR (5 downto 0);
           
           stack_pop : out STD_LOGIC;
           stack_push : out STD_LOGIC;
           stack_data_in : out STD_LOGIC_VECTOR (5 downto 0);
           
           game_over_out : out STD_LOGIC;
           game_won_out  : out STD_LOGIC;
           
           address_bus : out STD_LOGIC_VECTOR (5 downto 0);
           we_ram : out STD_LOGIC;
           data_to_ram : out STD_LOGIC_VECTOR (3 downto 0);
           rng_next : out STD_LOGIC_VECTOR (1 downto 0));
end component UC;

component Stack is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           push : in STD_LOGIC;
           pop : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (5 downto 0);
           data_out : out STD_LOGIC_VECTOR (5 downto 0));
           
end component Stack;

signal sig_start : STD_LOGIC;
signal sig_bombs : std_logic_vector (63 downto 0);
signal sig_rng_next : std_logic_vector (1 downto 0);
signal complete_map : bomb_array;

signal sig_pop: std_logic;
signal sig_push : std_logic;
signal sig_data_in_stack : std_logic_vector (5 downto 0);
signal sig_data_out_stack : std_logic_vector (5 downto 0);
begin

BOMB_POSITIONS_label : BOMB_POSITIONS port map ( clk => clk, reset => reset, seed => seed, mode => sig_rng_next, bombs_flat => sig_bombs, done => sig_start);
Minesweeper_game_map_label : Minesweeper_game_map port map (clk => clk, bombs_flat => sig_bombs, start => sig_start, map_mines => complete_map);
UC_label : UC port map (clk => clk, reset => reset, mouse_click => mouse_click, mouse_x => mouse_x, mouse_y => mouse_y, map_mines => complete_map,
                        stack_pop => sig_pop, stack_push => sig_push, stack_data_in => sig_data_in_stack, output_stack => sig_data_out_stack, rng_next => sig_rng_next,
                        address_bus => address_bus, we_ram => we_ram, data_to_ram => data_to_ram, game_over_out => game_over_out, game_won_out  => game_won_out);
Stack_label : Stack port map (clk => clk, rst_n => reset, push => sig_push, pop => sig_pop, data_in => sig_data_in_stack, data_out => sig_data_out_stack);


end Behavioral;
