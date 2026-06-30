----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2026 20:18:50
-- Design Name: 
-- Module Name: vga_counter - Behavioral
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

entity vga_counter is
    Port ( clk_100M : in STD_LOGIC;
           reset : in STD_LOGIC;
           color_index : in STD_LOGIC_VECTOR (3 downto 0);
           vga_hsync : out STD_LOGIC;
           vga_vsync : out STD_LOGIC;
           vga_r  : out STD_LOGIC_VECTOR(3 downto 0); -- Canalele de culoare
           vga_g : out STD_LOGIC_VECTOR(3 downto 0);
           vga_b : out STD_LOGIC_VECTOR(3 downto 0);
            
           -- Coordonate pentru a stii ce pixel sa citesti din RAM/ROM
           h_pixel : out STD_LOGIC_VECTOR(9 downto 0); 
           v_pixel : out STD_LOGIC_VECTOR(9 downto 0));
end vga_counter;

architecture Behavioral of vga_counter is

signal vga_clk : STD_LOGIC := '0';
signal clk_div : STD_LOGIC_VECTOR(1 downto 0) := "00";

signal h_cnt : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
signal v_cnt : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');

signal intensity : STD_LOGIC_VECTOR(3 downto 0);
    
begin

end Behavioral;
