package CrestronDLP
{
   public class StandardCommand
   {
      
      public static const CMD_NONE:uint = 0;
      
      public static const CMD_POWER_ON:uint = 1;
      
      public static const CMD_POWER_OFF:uint = 2;
      
      public static const CMD_VOLUME_UP:uint = 3;
      
      public static const CMD_VOLUME_DOWN:uint = 4;
      
      public static const CMD_MUTE:uint = 5;
      
      public static const CMD_MENU_UP:uint = 6;
      
      public static const CMD_MENU_DOWN:uint = 7;
      
      public static const CMD_MENU_LEFT:uint = 8;
      
      public static const CMD_MENU_RIGHT:uint = 9;
      
      public static const CMD_MENU:uint = 10;
      
      public static const CMD_MENU_ENTER:uint = 11;
      
      public static const CMD_MENU_EXIT:uint = 12;
      
      public static const CMD_HELP:uint = 13;
      
      public static const CMD_VOLUME:uint = 14;
      
      public static const CMD_WARMING_UP:uint = 15;
      
      public static const CMD_WARMING_VAL:uint = 16;
      
      public static const CMD_HELP_MSG:uint = 17;
      
      public static const CMD_JUMP_TO_TOOLS:uint = 18;
      
      public static const CMD_JUMP_TO_INFO:uint = 19;
      
      public static const CMD_CS_IP_ADDR:uint = 20;
      
      public static const CMD_CS_IP_ID:uint = 21;
      
      public static const CMD_CS_PORT:uint = 22;
      
      public static const CMD_PROJECTOR_NAME:uint = 23;
      
      public static const CMD_LOCATION:uint = 24;
      
      public static const CMD_IP_ADDR:uint = 25;
      
      public static const CMD_SUBNET_MASK:uint = 26;
      
      public static const CMD_DEFAULT_GATEWAY:uint = 27;
      
      public static const CMD_DNS_SERVER:uint = 28;
      
      public static const CMD_USER_NAME:uint = 29;
      
      public static const CMD_USER_PWRD:uint = 30;
      
      public static const CMD_USER_CONFIRM:uint = 31;
      
      public static const CMD_ADMIN_PWRD:uint = 32;
      
      public static const CMD_ADMIN_CONFIRM:uint = 33;
      
      public static const CMD_JUMP_TO_HELP:uint = 34;
      
      public static const CMD_U_PWRD_ENABLED:uint = 35;
      
      public static const CMD_A_PWRD_ENABLED:uint = 36;
      
      public static const CMD_DHCP_ENABLED:uint = 37;
      
      public static const CMD_FIRMWARE:uint = 38;
      
      public static const CMD_MAC_ADDR:uint = 39;
      
      public static const CMD_RESOLUTION:uint = 40;
      
      public static const CMD_LAMP_HOURS:uint = 41;
      
      public static const CMD_ASSIGNED_TO:uint = 42;
      
      public static const CMD_POWER_STATUS:uint = 43;
      
      public static const CMD_PRESET_MODE:uint = 44;
      
      public static const CMD_PROJ_POS:uint = 45;
      
      public static const CMD_LAMP_MODE:uint = 46;
      
      public static const CMD_ERROR_STATUS:uint = 47;
      
      public static const CMD_KEYPAD_EXT1:uint = 48;
      
      public static const CMD_KEYPAD_EXT2:uint = 49;
      
      public static const CMD_KEYPAD_EXT3:uint = 50;
      
      public static const CMD_KEYPAD_EXT4:uint = 51;
      
      public static const CMD_MUTE_OFF:uint = 52;
      
      public static const CMD_KEYPAD_EXT1_T:uint = 53;
      
      public static const CMD_KEYPAD_EXT2_T:uint = 54;
      
      public static const CMD_KEYPAD_EXT3_T:uint = 55;
      
      public static const CMD_KEYPAD_EXT4_T:uint = 56;
      
      public static const CMD_FIRST:uint = 1;
      
      public static const CMD_LAST:uint = 56;
      
      public static const CMD_LAMP_HOURS2:uint = 57;
      
      public static const TXT_POWER_ON:String = "power_on";
      
      public static const TXT_POWER_OFF:String = "power_off";
      
      public static const TXT_VOLUME_UP:String = "vol_up";
      
      public static const TXT_VOLUME_DOWN:String = "vol_down";
      
      public static const TXT_MUTE:String = "mute";
      
      public static const TXT_MUTE_OFF:String = "mute_off";
      
      public static const TXT_MENU_UP:String = "up";
      
      public static const TXT_MENU_DOWN:String = "down";
      
      public static const TXT_MENU_LEFT:String = "left";
      
      public static const TXT_MENU_RIGHT:String = "right";
      
      public static const TXT_MENU:String = "menu";
      
      public static const TXT_MENU_ENTER:String = "enter";
      
      public static const TXT_MENU_EXIT:String = "exit";
      
      public static const TXT_HELP:String = "help";
      
      public static const TXT_VOLUME:String = "volume";
      
      public static const TXT_WARMING_UP = "warming_up";
      
      public static const TXT_WARMING_VAL = "warming_val";
      
      public static const TXT_HELP_MSG = "help_msg";
      
      public static const TXT_JUMP_TO_TOOLS:String = "jump_to_tools";
      
      public static const TXT_JUMP_TO_INFO:String = "jump_to_info";
      
      public static const TXT_JUMP_TO_HELP:String = "jump_to_help";
      
      public static const TXT_CS_IP_ADDR:String = "cs_ipaddr";
      
      public static const TXT_CS_IP_ID:String = "cs_ipid";
      
      public static const TXT_CS_PORT:String = "cs_port";
      
      public static const TXT_PROJECTOR_NAME:String = "proj_name";
      
      public static const TXT_LOCATION:String = "location";
      
      public static const TXT_IP_ADDR:String = "ipaddr";
      
      public static const TXT_SUBNET_MASK:String = "subnet";
      
      public static const TXT_DEFAULT_GATEWAY:String = "gateway";
      
      public static const TXT_DNS_SERVER:String = "dns";
      
      public static const TXT_USER_NAME:String = "uname";
      
      public static const TXT_USER_PWRD:String = "upwd";
      
      public static const TXT_USER_CONFIRM:String = "uconfirm";
      
      public static const TXT_ADMIN_PWRD:String = "apwd";
      
      public static const TXT_ADMIN_CONFIRM:String = "aconfirm";
      
      public static const TXT_U_PWRD_ENABLED:String = "upwd_enabled";
      
      public static const TXT_A_PWRD_ENABLED:String = "apwd_enabled";
      
      public static const TXT_DHCP_ENABLED:String = "dhcp_enabled";
      
      public static const TXT_FIRMWARE:String = "firmware";
      
      public static const TXT_MAC_ADDR:String = "mac_addr";
      
      public static const TXT_RESOLUTION:String = "resolution";
      
      public static const TXT_LAMP_HOURS:String = "lamp_hours";
      
      public static const TXT_LAMP_HOURS2:String = "lamp_hours2";
      
      public static const TXT_ASSIGNED_TO:String = "assigned_to";
      
      public static const TXT_POWER_STATUS:String = "power_status";
      
      public static const TXT_PRESET_MODE:String = "preset_mode";
      
      public static const TXT_PROJ_POS:String = "proj_pos";
      
      public static const TXT_LAMP_MODE:String = "lamp_mode";
      
      public static const TXT_ERROR_STATUS:String = "error_status";
      
      public static const TXT_KEYPAD_EXT1:String = "menu_ext1";
      
      public static const TXT_KEYPAD_EXT2:String = "menu_ext2";
      
      public static const TXT_KEYPAD_EXT3:String = "menu_ext3";
      
      public static const TXT_KEYPAD_EXT4:String = "menu_ext4";
      
      public static const TXT_KEYPAD_EXT1_T:String = "menu_ext1_t";
      
      public static const TXT_KEYPAD_EXT2_T:String = "menu_ext2_t";
      
      public static const TXT_KEYPAD_EXT3_T:String = "menu_ext3_t";
      
      public static const TXT_KEYPAD_EXT4_T:String = "menu_ext4_t";
       
      
      public var cmd:uint = 0;
      
      public var join:uint = 0;
      
      public var lbl:String = "";
      
      public function StandardCommand(param1:String, param2:uint, param3:String)
      {
         super();
         switch(param1.toLowerCase())
         {
            case TXT_KEYPAD_EXT1:
               cmd = CMD_KEYPAD_EXT1;
               break;
            case TXT_KEYPAD_EXT2:
               cmd = CMD_KEYPAD_EXT2;
               break;
            case TXT_KEYPAD_EXT3:
               cmd = CMD_KEYPAD_EXT3;
               break;
            case TXT_KEYPAD_EXT4:
               cmd = CMD_KEYPAD_EXT4;
               break;
            case TXT_KEYPAD_EXT1_T:
               cmd = CMD_KEYPAD_EXT1_T;
               break;
            case TXT_KEYPAD_EXT2_T:
               cmd = CMD_KEYPAD_EXT2_T;
               break;
            case TXT_KEYPAD_EXT3_T:
               cmd = CMD_KEYPAD_EXT3_T;
               break;
            case TXT_KEYPAD_EXT4_T:
               cmd = CMD_KEYPAD_EXT4_T;
               break;
            case TXT_FIRMWARE:
               cmd = CMD_FIRMWARE;
               break;
            case TXT_MAC_ADDR:
               cmd = CMD_MAC_ADDR;
               break;
            case TXT_RESOLUTION:
               cmd = CMD_RESOLUTION;
               break;
            case TXT_LAMP_HOURS:
               cmd = CMD_LAMP_HOURS;
               break;
            case TXT_LAMP_HOURS2:
               cmd = CMD_LAMP_HOURS2;
               break;
            case TXT_ASSIGNED_TO:
               cmd = CMD_ASSIGNED_TO;
               break;
            case TXT_POWER_STATUS:
               cmd = CMD_POWER_STATUS;
               break;
            case TXT_PRESET_MODE:
               cmd = CMD_PRESET_MODE;
               break;
            case TXT_PROJ_POS:
               cmd = CMD_PROJ_POS;
               break;
            case TXT_LAMP_MODE:
               cmd = CMD_LAMP_MODE;
               break;
            case TXT_ERROR_STATUS:
               cmd = CMD_ERROR_STATUS;
               break;
            case TXT_U_PWRD_ENABLED:
               cmd = CMD_U_PWRD_ENABLED;
               break;
            case TXT_A_PWRD_ENABLED:
               cmd = CMD_A_PWRD_ENABLED;
               break;
            case TXT_DHCP_ENABLED:
               cmd = CMD_DHCP_ENABLED;
               break;
            case TXT_POWER_ON:
               cmd = CMD_POWER_ON;
               break;
            case TXT_POWER_OFF:
               cmd = CMD_POWER_OFF;
               break;
            case TXT_VOLUME_UP:
               cmd = CMD_VOLUME_UP;
               break;
            case TXT_VOLUME_DOWN:
               cmd = CMD_VOLUME_DOWN;
               break;
            case TXT_MUTE:
               cmd = CMD_MUTE;
               break;
            case TXT_MUTE_OFF:
               cmd = CMD_MUTE_OFF;
               break;
            case TXT_MENU_UP:
               cmd = CMD_MENU_UP;
               break;
            case TXT_MENU_DOWN:
               cmd = CMD_MENU_DOWN;
               break;
            case TXT_MENU_LEFT:
               cmd = CMD_MENU_LEFT;
               break;
            case TXT_MENU_RIGHT:
               cmd = CMD_MENU_RIGHT;
               break;
            case TXT_MENU:
               cmd = CMD_MENU;
               break;
            case TXT_MENU_ENTER:
               cmd = CMD_MENU_ENTER;
               break;
            case TXT_MENU_EXIT:
               cmd = CMD_MENU_EXIT;
               break;
            case TXT_HELP:
               cmd = CMD_HELP;
               break;
            case TXT_VOLUME:
               cmd = CMD_VOLUME;
               break;
            case TXT_WARMING_UP:
               cmd = CMD_WARMING_UP;
               break;
            case TXT_WARMING_VAL:
               cmd = CMD_WARMING_VAL;
               break;
            case TXT_HELP_MSG:
               cmd = CMD_HELP_MSG;
               break;
            case TXT_JUMP_TO_TOOLS:
               cmd = CMD_JUMP_TO_TOOLS;
               break;
            case TXT_JUMP_TO_INFO:
               cmd = CMD_JUMP_TO_INFO;
               break;
            case TXT_JUMP_TO_HELP:
               cmd = CMD_JUMP_TO_HELP;
               break;
            case TXT_CS_IP_ADDR:
               cmd = CMD_CS_IP_ADDR;
               break;
            case TXT_CS_IP_ID:
               cmd = CMD_CS_IP_ID;
               break;
            case TXT_CS_PORT:
               cmd = CMD_CS_PORT;
               break;
            case TXT_PROJECTOR_NAME:
               cmd = CMD_PROJECTOR_NAME;
               break;
            case TXT_LOCATION:
               cmd = CMD_LOCATION;
               break;
            case TXT_IP_ADDR:
               cmd = CMD_IP_ADDR;
               break;
            case TXT_SUBNET_MASK:
               cmd = CMD_SUBNET_MASK;
               break;
            case TXT_DEFAULT_GATEWAY:
               cmd = CMD_DEFAULT_GATEWAY;
               break;
            case TXT_DNS_SERVER:
               cmd = CMD_DNS_SERVER;
               break;
            case TXT_USER_NAME:
               cmd = CMD_USER_NAME;
               break;
            case TXT_USER_PWRD:
               cmd = CMD_USER_PWRD;
               break;
            case TXT_USER_CONFIRM:
               cmd = CMD_USER_CONFIRM;
               break;
            case TXT_ADMIN_PWRD:
               cmd = CMD_ADMIN_PWRD;
               break;
            case TXT_ADMIN_CONFIRM:
               cmd = CMD_ADMIN_CONFIRM;
         }
         join = param2;
         lbl = param3;
      }
   }
}
