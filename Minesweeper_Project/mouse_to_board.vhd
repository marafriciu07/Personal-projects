----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2026 20:10:52
-- Design Name: 
-- Module Name: mouse_to_board - Behavioral
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

entity mouse_to_board is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ps2_clk : inout STD_LOGIC;
           ps2_data : inout STD_LOGIC;
           mouse_click : out STD_LOGIC;
           
           mouse_x : out STD_LOGIC_VECTOR (2 downto 0);
           mouse_y : out STD_LOGIC_VECTOR (2 downto 0);
           
           mouse_xpos : out STD_LOGIC_VECTOR(11 downto 0);
           mouse_ypos : out STD_LOGIC_VECTOR(11 downto 0));
end mouse_to_board;

architecture Behavioral of mouse_to_board is

component MouseCtl is
generic
(
   SYSCLK_FREQUENCY_HZ : integer := 100000000;
   CHECK_PERIOD_MS     : integer := 500; -- Period in miliseconds to check if the mouse is present
   TIMEOUT_PERIOD_MS   : integer := 100 -- Timeout period in miliseconds when the mouse presence is checked
);
port(
   clk         : in std_logic;
   rst         : in std_logic;
   xpos        : out std_logic_vector(11 downto 0);
   ypos        : out std_logic_vector(11 downto 0);
   zpos        : out std_logic_vector(3 downto 0);
   left        : out std_logic;
   middle      : out std_logic;
   right       : out std_logic;
   new_event   : out std_logic;
   value       : in std_logic_vector(11 downto 0);
   setx        : in std_logic;
   sety        : in std_logic;
   setmax_x    : in std_logic;
   setmax_y    : in std_logic;
   
   ps2_clk     : inout std_logic;
   ps2_data    : inout std_logic
   
);
end component MouseCtl;

constant BOARD_X0   : integer := 192; -- horizontal start
constant BOARD_Y0   : integer := 112; -- vertical start
constant CELL_SIZE  : integer := 32;
constant BOARD_SIZE : integer := 256; -- 8 * 32

signal xpos_s      : STD_LOGIC_VECTOR(11 downto 0);
signal ypos_s      : STD_LOGIC_VECTOR(11 downto 0);
signal zpos_s      : STD_LOGIC_VECTOR(3 downto 0);
signal left_s      : STD_LOGIC;
signal middle_s    : STD_LOGIC;
signal right_s     : STD_LOGIC;
signal new_event_s : STD_LOGIC;

signal value_s     : STD_LOGIC_VECTOR(11 downto 0);
signal setx_s      : STD_LOGIC := '0';
signal sety_s      : STD_LOGIC := '0';
signal setmax_x_s  : STD_LOGIC := '0';
signal setmax_y_s  : STD_LOGIC := '0';

signal init_step   : integer range 0 to 5 := 0;
signal left_prev   : STD_LOGIC := '0';

begin

MOUSE_label : MouseCtl port map (clk => clk, rst => rst, xpos => xpos_s, ypos => ypos_s, zpos => zpos_s, left => left_s, 
                                 right => right_s, middle => middle_s, new_event => new_event_s, value => value_s, setx => setx_s,
                                 sety => sety_s, setmax_x => setmax_x_s, setmax_y => setmax_y_s, ps2_clk => ps2_clk, ps2_data => ps2_data);

value_s <= conv_std_logic_vector(639, 12)      when init_step = 1 else
           conv_std_logic_vector(479, 12)      when init_step = 2 else
           conv_std_logic_vector(BOARD_X0, 12) when init_step = 3 else
           conv_std_logic_vector(BOARD_Y0, 12) when init_step = 4 else
           (others => '0');                   

setmax_x_s <= '1' when init_step = 1 else '0';
setmax_y_s <= '1' when init_step = 2 else '0';
setx_s     <= '1' when init_step = 3 else '0';
sety_s     <= '1' when init_step = 4 else '0';

process(clk, rst)
    variable sx  : integer;
    variable sy  : integer;
    variable row : integer;
    variable col : integer;
begin
    if rst = '1' then
        init_step    <= 0;
        left_prev    <= '0';
        mouse_click  <= '0';
        mouse_x      <= "000";
        mouse_y      <= "000";

    elsif rising_edge(clk) then
        mouse_click <= '0';

        -- run init only once
        if init_step < 5 then
            init_step <= init_step + 1;
        end if;

        -- detect click only when a new mouse packet arrived
        if new_event_s = '1' then
            sx := conv_integer(xpos_s); -- horizontal screen position
            sy := conv_integer(ypos_s); -- vertical screen position

            -- my convention:
            -- mouse_x = vertical / row
            -- mouse_y = horizontal / column
            if (sx >= BOARD_X0) and (sx < BOARD_X0 + BOARD_SIZE) and
               (sy >= BOARD_Y0) and (sy < BOARD_Y0 + BOARD_SIZE) then

                row := (sy - BOARD_Y0) / CELL_SIZE;
                col := (sx - BOARD_X0) / CELL_SIZE;

                mouse_x <= conv_std_logic_vector(row, 3);
                mouse_y <= conv_std_logic_vector(col, 3);

                if (left_s = '1') and (left_prev = '0') then
                    mouse_click <= '1';
                end if;
            end if;
            left_prev <= left_s;
        end if;
    end if;
end process;

mouse_xpos <= xpos_s;
mouse_ypos <= ypos_s;
end Behavioral;
