----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2026 09:15:19
-- Design Name: 
-- Module Name: BOMB_POSITIONS - Behavioral
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

entity BOMB_POSITIONS is
    Port ( clk : in STD_LOGIC;
           seed : in STD_LOGIC_VECTOR (5 downto 0);
           reset : in STD_LOGIC;
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           bombs_flat : out STD_LOGIC_VECTOR (63 downto 0);
           done : out STD_LOGIC);
end BOMB_POSITIONS;

architecture Behavioral of BOMB_POSITIONS is

component RNG is
    Port ( clk : in STD_LOGIC;
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           seed : in STD_LOGIC_vECTOR (5 downto 0);
           q_out : out STD_LOGIC_VECTOR (5 downto 0));
end component RNG;

component Bomb_Generator is
    Port ( clk : in STD_LOGIC;
           rng_in : in STD_LOGIC_VECTOR (5 downto 0);
           reset : in STD_LOGIC;
           done : out STD_LOGIC;
           bombs_flat : out STD_LOGIC_VECTOR (63 downto 0));
end component Bomb_Generator;

signal wire1 : std_logic_vector (5 downto 0);

begin

RNG_label: RNG port map (seed => seed, mode => mode, clk => clk, q_out => wire1);
Bomb_Generator_label: Bomb_Generator port map (clk => clk, reset => reset, rng_in => wire1, bombs_flat => bombs_flat, done => done);

end Behavioral;
