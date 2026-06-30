----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2026 23:33:00
-- Design Name: 
-- Module Name: UC - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.std_logic_arith.ALL;
use work.bombs_integer.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
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
end UC;

architecture Behavioral of UC is
type state_type is (ST_start, ST_initialize, ST_idle, ST_checkcell, ST_pushfirst, ST_pop,
                     ST_Readcell, ST_checkvalue, ST_pushneighbors, ST_checkstack, ST_okbomb,
                     ST_gamewon, ST_exit, ST_gameover, ST_waitclock);
signal next_state : state_type;
signal neighbor_cnt : integer range 0 to 7 := 0;
signal is_visited: std_logic_vector (63 downto 0); 
signal wait_stack : std_logic_vector (5 downto 0);

--folosim semnale ca sa persiste printre clock-urile din pushneigh.
signal x: integer;
signal y: integer;
signal index: integer;
signal signal_empty_stack: integer := 0;

constant NR_BOMBE : integer := 10;
constant NR_SAFE  : integer := 64 - NR_BOMBE;

signal opened_count : integer range 0 to 64 := 0;

begin

process(clk, reset)

variable vindex, vx, vy, real_value, empty_stack: integer;

begin
    if reset = '1' then
        next_state <= ST_start;
        is_visited <= (others => '0');
        neighbor_cnt <= 0;
        opened_count <= 0;
        we_ram <= '0';
        empty_stack := 0; -- resetam si variabila interna
        rng_next <= "11";
        game_over_out <= '0';
        game_won_out  <= '0';
        signal_empty_stack <= 0;
    elsif rising_edge(clk) then
        signal_empty_stack <= empty_stack; -- actualizare la fiecare clock cand e pe rising_edge pentru a nu pierde valoarea
        we_ram <= '0';
        stack_push <= '0';
        stack_pop <= '0';

        case next_state is 
            when ST_start => next_state <= ST_initialize;
            when ST_initialize => rng_next <= "01";
                                  next_state <= ST_idle;
            when ST_idle => if mouse_click = '1' then next_state <=ST_checkcell;
                            else next_state <= ST_idle;
                            end if;
            when ST_checkcell => vx := conv_integer(mouse_x(2 downto 0));
                                 vy := conv_integer(mouse_y(2 downto 0));
                                 vindex := vx * 8 + vy;
                                 if map_mines(vindex)= 9 then
                                    we_ram <= '1';
                                    address_bus <= mouse_x & mouse_y;
                                    data_to_ram <= "1001"; -- bomb tile
                                    next_state <= ST_gameover;
                                 else 
                                      next_state <= ST_pushfirst;
                                 end if;
                                 
            when ST_pushfirst => stack_push <= '1';
                                 stack_pop <= '0';
                                 empty_stack := empty_stack + 1;
                                 stack_data_in <= mouse_x & mouse_y;
                                 next_state <= ST_pop;
            when ST_pop => stack_pop <= '1';
                           stack_push <= '0';
                           empty_stack := empty_stack - 1;
                           next_state <= ST_waitclock;
                           
            when ST_waitclock => next_state <= ST_readcell;
                           
            when ST_readcell =>  vx := conv_integer(output_stack(5 downto 3));
                                 vy := conv_integer(output_stack(2 downto 0));
                                 vindex := vx * 8 + vy;
                                 x <= vx;
                                 y <= vy;
                                 index <= vindex;
                                 wait_stack <= output_stack;
                                 next_state <= ST_checkvalue;
         
            when ST_checkvalue => if is_visited(index) = '1' then
                                    next_state <= ST_checkstack;
                                  else 
                                  is_visited(index) <= '1';
                                  opened_count <= opened_count + 1;
                                  
                                  we_ram <= '1'; --"La adresa X, nu mai desena un patratel gri închis, 
                                                 --ci deseneaza cifra (sau spatiul gol) care se afla în map_mines la acea locatie."
                                  address_bus <= wait_stack;
                                  real_value := map_mines(index);                               
                                  data_to_ram <= conv_std_logic_vector(real_value, 4);
                                  
                                    if real_value = 0 then 
                                        next_state <= ST_pushneighbors;
                                    else next_state <= ST_checkstack;
                                    end if;
                                  end if;
                      
            when ST_pushneighbors => if map_mines(index) = 0 then
                                     stack_push <= '0'; -- default
                                     case neighbor_cnt is
                                        when 0 => -- RIGHT
                                             if y < 7 and is_visited(index + 1) = '0' then
                                               stack_push <= '1';
                                               empty_stack := empty_stack + 1;
                                               stack_data_in <= conv_std_logic_vector(index + 1, 6);
                                             end if;
    
                                       when 1 => -- LEFT
                                            if y > 0 and is_visited(index - 1) = '0' then
                                                stack_push <= '1';
                                                empty_stack := empty_stack + 1;
                                                stack_data_in <= conv_std_logic_vector(index - 1, 6);
                                            end if;
                                
                                        when 2 => -- UP
                                            if x > 0 and is_visited(index - 8) = '0' then
                                                stack_push <= '1';
                                                empty_stack := empty_stack + 1;
                                                stack_data_in <= conv_std_logic_vector(index - 8, 6);
                                            end if;
                                
                                        when 3 => -- DOWN
                                            if x < 7 and is_visited(index + 8) = '0' then
                                                stack_push <= '1';
                                                empty_stack := empty_stack + 1;
                                                stack_data_in <= conv_std_logic_vector(index + 8, 6);
                                            end if;
                                
                                        when 4 => -- UP-RIGHT
                                            if x > 0 and y < 7 and is_visited(index - 7) = '0'then
                                                stack_push <= '1';
                                                empty_stack := empty_stack + 1;
                                                stack_data_in <= conv_std_logic_vector(index - 7, 6);
                                            end if;
                                
                                        when 5 => -- UP-LEFT
                                            if x > 0 and y > 0 and is_visited(index - 9) = '0' then
                                                stack_push <= '1';
                                                empty_stack := empty_stack + 1;
                                                stack_data_in <= conv_std_logic_vector(index - 9, 6);
                                            end if;
                                
                                        when 6 => -- DOWN-LEFT
                                            if x < 7 and y > 0 and is_visited(index + 7) = '0' then
                                                stack_push <= '1';
                                                empty_stack := empty_stack + 1;
                                                stack_data_in <= conv_std_logic_vector(index + 7, 6);
                                            end if;
                                
                                        when 7 => -- DOWN-RIGHT
                                            if x < 7 and y < 7 and is_visited(index + 9) = '0' then
                                                stack_push <= '1';
                                                empty_stack := empty_stack + 1;
                                                stack_data_in <= conv_std_logic_vector(index + 9, 6);
                                            end if;
                                
                                        when others => null;
                                    end case;
                                    else  neighbor_cnt <= 7;
                                    end if;
                                    if neighbor_cnt = 7 then
                                        neighbor_cnt <= 0;
                                        next_state <= ST_checkstack;
                                    else
                                        neighbor_cnt <= neighbor_cnt + 1;
                                        next_state <= ST_pushneighbors;
                                    end if;
            when ST_checkstack => if signal_empty_stack = 0 then next_state <= ST_okbomb;
                                  else next_state <= ST_pop;
                                  end if;
            when ST_okbomb =>  if opened_count = NR_SAFE then
                                   next_state <= ST_gamewon;
                               else
                                   next_state <= ST_idle;
                               end if;
            when ST_gamewon =>  game_won_out <= '1';
                                next_state <= ST_exit;
            when ST_gameover => game_over_out <= '1';
                                next_state <= ST_exit;
            when ST_exit => next_state <= ST_exit;
            when others => next_state <= ST_start;
        end case;
    end if;
end process;

end Behavioral;
