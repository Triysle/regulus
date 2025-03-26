# Regulus: Battle for Unobtanium
# Game Systems Design Document

## Table of Contents
1. [Combat Mechanics](#1-combat-mechanics)
2. [Resource System](#2-resource-system)
3. [Construction System](#3-construction-system)
4. [Player Progression System](#4-player-progression-system)
5. [Squad and Team Systems](#5-squad-and-team-systems)
6. [Territory Control System](#6-territory-control-system)
7. [Vehicle Systems](#7-vehicle-systems)
8. [User Interface and Player Experience](#8-user-interface-and-player-experience)

---

## 1. Combat Mechanics

### Time-to-Kill (TTK)
- **Target Experience**: Higher TTK similar to Halo, where players survive long enough for tactical decisions during combat
- **Standard Engagement**: Most encounters should last several seconds, not instant kills
- **Critical Damage**: Well-placed shots can still do elevated damage in certain scenarios

### Defensive Systems
#### Shield System
- Shields regenerate automatically after a period (3-5 seconds) of taking no damage
- Shield customization options:
  - High-capacity shields (more shield points, slower recharge)
  - Rapid-recharge shields (fewer shield points, faster recharge)
  - Specialized shields (resistance to specific damage types, vulnerability to others)
- Visual indicator: Solid bar that depletes and recharges

#### Armor System
- Armor functions as a consumable damage buffer between shields and health
- Does not regenerate automatically; requires repair stations or items
- Armor customization options:
  - Light armor (1-2 bars, minimal movement penalty)
  - Medium armor (3 bars, moderate movement penalty)
  - Heavy armor (4-5 bars, significant movement penalty)
  - Specialized armor (resistance to specific damage types)
- Visual indicator: Segmented bars that deplete as armor is damaged

#### Health System
- Health does not regenerate automatically
- Restored through medical items or healing stations
- Health customization:
  - Base health level ranges from 10-30 ticks based on equipment choices
  - Health restoration items vary in effectiveness and usage speed
- Visual indicator: Health ticks that deplete with damage

### Damage Types and Effectiveness
| Damage Type | vs. Shields | vs. Armor | vs. Health |
|-------------|-------------|-----------|------------|
| Kinetic     | Low         | Medium    | High       |
| Energy      | High        | Low       | Medium     |
| Explosive   | Medium      | High      | Low        |

### Combat Formula
1. Incoming damage is applied to shields first until depleted
2. Remaining damage is applied to armor (if equipped) until destroyed
3. Any remaining damage is applied directly to health
4. Death occurs when health reaches zero

### Combat Feedback
#### For Damage Dealer
- Visual crosshair indicators:
  - Yellow diamond flash: Shield damage
  - Cyan X flash: Armor damage
  - Red circle flash: Health damage
- Shield break effect: Visual fizzling effect when target's shield depletes
- Distinct audio cues for each damage type and hit confirmation

#### For Damage Receiver
- Health/armor/shield bars visibly depleting
- Directional damage indicators around screen edges
  - Yellow flashes: Energy damage incoming
  - Cyan flashes: Explosive damage incoming
  - Red flashes: Kinetic damage incoming
- Distinct audio cues for taking different damage types
- Screen effects intensify as health decreases

### Weapon Balance Parameters
- Damage per shot
- Fire rate
- Accuracy/recoil
- Reload time
- Magazine capacity
- Effective range
- Special effects (e.g., area damage, damage over time)

---

## 2. Resource System

### Ʉnobtainium (Ʉ)
- **Primary Resource**: Ʉnobtainium is the sole resource that players directly interact with
- **Function**: Universal currency for construction, equipment, and support abilities
- **Visual Representation**: Glowing crystalline material with faction-colored tint in UI

### Resource Collection
- **Extraction Method**: Players use specialized vehicles with extractor modules
- **Extraction Process**:
  1. Locate a Ʉ node in the world
  2. Position extraction vehicle at the node
  3. Activate extraction module
  4. Transport Ʉ to storage silo
- **Collection Rate**: Determined by node size and purity

### Resource Node Types
#### Size Categories
- **Small Node**: Lower total yield, faster to deplete
- **Medium Node**: Moderate yield and depletion time
- **Large Node**: High total yield, takes longer to deplete

#### Purity Ratings
- **Diffuse**: Low yield rate (1x multiplier)
- **Concentrated**: Medium yield rate (2x multiplier)
- **Crystalline**: High yield rate (3x multiplier)

### Resource Storage and Transport
- **Player Inventory**: Players cannot carry Ʉ directly
- **Vehicle Storage**: Specialized vehicles can transport Ʉ from nodes to silos
- **Storage Silos**: Faction-controlled structures that store Ʉ for use in a local area
- **Storage Capacity**: Determined by silo size and upgrades

### Resource Economy
- **Faction Sharing**: Ʉ is a shared resource for the entire faction
- **Spending Restrictions**:
  - Basic equipment always available regardless of Ʉ levels
  - Advanced equipment requires sufficient Ʉ and appropriate player rank
  - Vehicle and structure costs scale with power/utility
  - Team leaders and commanders have access to special requisitions

### Resource Distribution
- **Node Spawning**: Preset locations with randomized size and purity
- **Distribution Logic**: Ensures balanced access for all factions in the starting areas
- **Strategic Value**: Higher-yield nodes are positioned to encourage conflict
- **Depletion Mechanics**: Nodes gradually deplete with use but regenerate over time when a zone is inactive

---

## 3. Construction System

### Structure Types

#### Static Structures
- Pre-placed defensive and strategic structures
- **Examples**: Walls, bunkers, gates, bridges
- Cannot be built by players, only repaired when damaged
- All players can repair regardless of rank
- Require Ʉ for repairs

#### Dynamic Structures
- Player-built functional structures on foundations
- **Available Types**:
  - **Defensive**: Turrets, shield generators, sensor arrays
  - **Utility**: Respawn points, ammunition dispensers, repair stations
  - **Resource**: Ʉ storage silos, refineries
  - **Vehicle**: Garages, vehicle repair bays
- Rank requirements for selecting structure blueprints
- All players can contribute Ʉ to construction once blueprint is placed

### Building System

#### Foundation System
- **Small Foundation**: 1x1 unit, supports basic structures
- **Medium Foundation**: 2x2 units, supports intermediate structures
- **Large Foundation**: 3x3 units, supports advanced structures
- Foundations are pre-placed in strategic locations throughout the map

#### Construction Process
1. Player with appropriate rank selects blueprint for foundation
2. Blueprint hologram appears, showing Ʉ requirements
3. Players contribute Ʉ to construction
4. Structure builds progressively as resources are added
5. Structure becomes operational once fully built

### Structure Health and Damage
- Structures have their own shield/armor/health systems
- Can be damaged and destroyed by enemy weapons
- Repair mechanics allow friendly players to restore damaged structures
- Destruction returns foundation to neutral state for new construction

### Structure Upgrading
- Most structures have 1-3 upgrade levels
- Upgrades improve functionality, durability, or efficiency
- Require additional Ʉ investment
- Upgrading resets part of the construction process

### Structure Visual Representation
- Base structure functionality is identical across factions
- Visual appearance varies significantly by faction:
  - **Meridian Corporation**: Angular, sleek, blue and white
  - **Coalition of Free Miners**: Rugged, practical, orange and brown
  - **Luminous Path**: Organic, flowing, green and purple
- Structure state is visually apparent (under construction, damaged, operational)

### Structure Demolition
- Friendly structures can be demolished by appropriate rank players
- Returns a portion of invested Ʉ (40-60%)
- Enables strategic reallocation of resources

---

## 4. Player Progression System

### Rank Advancement
- **Primary XP Sources**:
  - **Objective Participation**: Capturing points, defending bases (highest XP)
  - **Team Support**: Healing, repairing, resupplying teammates
  - **Combat**: Eliminating enemies, assisting teammates, destroying vehicles/structures
  - **Following Orders**: Bonus XP for completing tasks marked by team leaders
- **Rank Structure**: Follows the established 30-rank system per faction (see faction ranks document)

### Unlock System
- **Weapon Unlocks**: New weapon options become available at higher ranks
- **Vehicle Access**: Additional vehicle frames and customizations
- **Structure Blueprints**: More advanced structures can be placed
- **Equipment Options**: Enhanced armor, shields, and utility items
- **Specialization Paths**: Players can choose to unlock certain powerful options at the cost of locking others

### Equipment Progression
- **Individual Progression**: Each weapon/vehicle progresses separately with use
- **Equipment Upgrades**: Using specific equipment unlocks modifications and attachments
- **Specialization**: Players gradually build expertise with preferred loadouts

### Prestige System
- **Character Prestige**:
  - Reset rank progression to Rank 1
  - Retain unlocked equipment access
  - Earn unique cosmetic items and titles
  - Slight permanent boost to XP gain (stacking with each prestige)
- **Equipment Prestige**:
  - Reset individual weapon/vehicle progression
  - Earn unique weapon/vehicle skins
  - Unlock enhanced modification slots

### Cosmetic Progression
- **Basic Cosmetics**: Available through rank progression
- **Specialized Cosmetics**: Unlocked through achievements and challenges
- **Prestige Cosmetics**: Unique visual identifiers for prestiged players
- **Faction Pride**: Special cosmetics for contributing to faction victories

---

## 5. Squad and Team Systems

### Team Structure
- **Players Per Faction**: 33 players
- **Command Structure**:
  - 1 Commander
  - 4 Teams of 8 players each (1 Team Leader + 7 members)
- **Game Moderation**: 1 "Overseer" slot reserved for admin/moderator (100th player)

### Team Formation
- Structure is predefined but participation is flexible
- Players can join any team with available slots
- System encourages filling understrength teams

### Team Leader Abilities
- **Marking System**: Place objective markers visible to team
  - Attack markers
  - Defend markers
  - Resource priority markers
  - Support needed markers
- **Support Requisition**: Request support options from Commander
  - Reinforcement beacons (temporary respawn points)
  - Supply drops (health, armor, ammunition)
  - Vehicle deliveries
  - Indirect fire support
- **Squad Management**: View team member status and loadouts

### Commander Abilities
- **Strategic Oversight**: Full map visibility and enhanced intelligence
- **Objective Assignment**: Assign territories and missions to teams
  - Teams following assignments receive XP bonuses
- **Support Approval**: Approve or deny team leader support requests
- **Direct Support**: Call in faction-wide support abilities
  - Orbital bombardments
  - UAV scans
  - Emergency supply drops
- **Inspiration**: Provide buffs to nearby teammates when on frontlines

### Team Benefits
- **XP Bonuses**: Additional XP for operating near teammates
- **Support Synergy**: Enhanced effectiveness of support abilities when used as a team
- **Resource Efficiency**: Reduced Ʉ costs for team-coordinated vehicle spawns
- **Combat Effectiveness**: Combat bonuses when engaging the same targets

### Communication System
- **Ping System**: Contextual marking system for quick communication
  - Enemy spotted
  - Resource node identified
  - Help needed
  - Rally point
- **Team Chat**: Text and voice communication within team
- **Commander Channel**: Direct communication between team leaders and commander
- **Faction Announcements**: Commander can send faction-wide text alerts

---

## 6. Territory Control System

### Zone Layout
- **Hexagonal Zones**: Each discrete battlefield is a large hexagonal area
- **Starting Bases**: Each faction has one starting base (3 total) in a triangular arrangement
- **Primary Objective**: Large central base as the main point of contention
- **Secondary Objectives**: Three secondary bases positioned equidistant from starting bases
- **Outposts**: Smaller control points forming a "lattice" network connecting objectives

### Base Types
- **Starting Bases**: Permanent faction ownership, cannot be captured
  - High defensive capabilities
  - Limited but reliable Ʉ generation
  - Basic equipment and vehicle terminals
  
- **Outposts**: Small strategic points
  - Few static structures
  - 1-2 small building foundations
  - No direct Control Point generation
  - Required for lattice connectivity to larger objectives
  
- **Secondary Objectives**: Medium-sized bases
  - Several static structures
  - 3-5 building foundations (small/medium)
  - Generates 1 Control Point per minute for controlling faction
  
- **Primary Objective**: Large central fortress
  - Numerous static structures
  - 7-10 building foundations (small to large)
  - Generates 2 Control Points per minute for controlling faction

### Capture Mechanics
- **Lattice System**: Objectives can only be captured if connected to already-owned territory
- **Capture Process**:
  1. Establish presence in objective area
  2. Neutralize enemy ownership (if present)
  3. Convert to friendly ownership
  4. Defend until secure
- **Capture Speed**: Affected by number of players present and construction of specific structures

### Territory Control Score
- **Control Points**: Currency for territory dominance
- **Point Generation**:
  - Secondary Objective: +1 point per minute
  - Primary Objective: +2 points per minute
- **Point Decay**: All factions lose 1 point per minute (minimum 0)
- **Victory Condition**: First faction to reach 100 Control Points

### Territory Locking
- **Lock Duration**: Minimum 60 minutes after reaching victory condition
- **Active Zones**: Only three zones can be contested simultaneously
- **Zone Selection**: System prioritizes zones creating interesting frontlines
- **Cooldown Period**: Prevents immediate recapture of recently contested zones

### Strategic Benefits
- **Resource Production**: Controlling territory increases faction Ʉ income
- **Spawn Options**: Additional respawn locations
- **Equipment Access**: Specialized equipment terminals
- **Strategic Positioning**: Advantageous positions for future territory expansion

---

## 7. Vehicle Systems

### Vehicle Framework
- **Base Frames**: Three distinct vehicle platforms with different characteristics
  1. **Light Frame**: Fast, agile, lower health, 1-2 crew capacity
  2. **Medium Frame**: Balanced speed/durability, 2-3 crew capacity
  3. **Heavy Frame**: Slow, durable, 3-4 crew capacity

### Vehicle Modules
- **Propulsion Systems**: Determine movement characteristics
  - Standard wheels
  - Hover systems
  - Treads
  - Specialized terrain adaptations
- **Weapon Systems**: Determine combat capabilities
  - Kinetic weapons (physical projectiles)
  - Energy weapons (shield-focused damage)
  - Explosive weapons (area damage)
  - Support systems (repair, shield boosting)
- **Utility Systems**: Provide specialized functions
  - Ʉ extraction
  - Ʉ transport capacity
  - Mobile spawn point
  - Radar/detection
  - Defensive countermeasures

### Vehicle Acquisition
- **Requisition Method**: Vehicles are spawned at garage structures
- **Cost**: Ʉ cost varies based on frame and modules
- **Cooldown**: Personal cooldown timer after vehicle destruction
- **Rank Requirements**: More advanced vehicles require higher ranks

### Vehicle Health System
- **Three-Layer Defense**: Similar to player system
  - **Shields**: Regenerate automatically after not taking damage
  - **Armor**: Must be repaired, does not regenerate
  - **Hull Integrity**: Core health of the vehicle
- **Critical Systems**: Vehicles can have systems damaged individually
  - Mobility impairment
  - Weapon system failures
  - Module malfunctions
- **Repair Options**:
  - Repair tools (players)
  - Repair stations (structures)
  - Repair modules (support vehicles)

### Vehicle Combat Balance
- **Vehicle vs. Vehicle**: Based on vehicle class and weapon systems
  - Light vehicles: Effective against infantry, vulnerable to medium/heavy vehicles
  - Medium vehicles: Balanced effectiveness against all targets
  - Heavy vehicles: Specialized for anti-vehicle combat
  
- **Vehicle vs. Infantry**: Requires balance to prevent domination
  - Infantry have access to anti-vehicle weapons
  - Vehicles have blind spots and vulnerabilities
  - Environmental cover provides infantry protection

### Vehicle Customization
- **Visual Customization**: Allows personalization without affecting function
  - Paint schemes
  - Decals
  - Trim and details
- **Functional Customization**: Affects performance characteristics
  - Module selection
  - Component tuning
  - Specialization paths

---

## 8. User Interface and Player Experience

### HUD Elements
- **Player Status** (Bottom Left):
  - Shield bar (solid, recharges automatically)
  - Armor bars (1-5 segments based on equipment)
  - Health ticks (10-30 based on equipment)
  
- **Weapon Information** (Bottom Left, above status):
  - Weapon icon/outline
  - Ammo count (current/total)
  - Secondary weapon indicator
  - Active item/quantity
  
- **Minimap** (Bottom Right):
  - Shows nearby friendly players
  - Shows spotted enemies
  - Displays team objectives
  - Indicates resource nodes
  
- **Territory Control** (Above Minimap):
  - Progress bar showing control points for each faction
  
- **Directional Elements** (Center):
  - Persistent crosshair
  - Hit markers (colored based on damage type)
  
- **Navigation** (Top Center):
  - Compass/bearing indicator
  - Objective distance markers
  
- **Combat Feed** (Top Right):
  - Kill notifications
  - Point capture alerts
  
- **Team Status** (Top Left):
  - Current objectives and progress
  - Team roster showing:
    - Commander
    - Team leader
    - Team members
    - Specialization icons
    - Health status (red flash = taking damage, grey = dead)

### Map Interface
- **Territory Overview**: Shows all zones and their control status
- **Active Zone Map**: Detailed view of current battlefield
  - Outpost and objective locations
  - Ownership status with faction colors
  - Resource node locations
  - Squad member positions
  - Friendly structure locations
- **Base Information**: Hover functionality to show:
  - List of operational structures
  - Spawn availability
  - Current defenders/attackers
- **Strategic Tools**: Drawing and marking tools for commanders and team leaders

### Notification System
- **Objective Updates** (Top Center):
  - Base capture progress
  - Control point generation
  - Territory lock warnings
- **Team Communications** (Center Left):
  - Orders from team leaders/commander
  - Squad member status updates
- **Resource Alerts** (Bottom Center):
  - Ʉ silo status
  - Resource node discoveries
- **Game Events** (Full Screen):
  - Territory victory/defeat
  - Zone activation/deactivation

### Loadout Management
- **Equipment Slots**:
  - Primary weapon
  - Secondary weapon
  - Shield unit
  - Armor type
  - Utility items (up to 3)
- **Loadout Presets**: Save up to 5 custom configurations
- **Quick Swap**: Fast switching between saved loadouts at equipment terminals
- **Visual Preview**: 3D model preview of character with selected equipment

### Quality of Life Features
- **Quick Actions**: Contextual interaction menu
- **Auto-run**: Toggle for continuous forward movement
- **Quick Voice Lines**: Preset communication options
- **Settings Access**: Easily accessible options menu
- **Performance Monitoring**: Optional FPS and ping display
- **Death Camera**: Brief killcam showing how player was defeated

### Accessibility Features
- **Colorblind Modes**: Multiple options for different types of color vision deficiency
- **Text Size Adjustment**: Scalable UI elements
- **Audio Cues**: Visual indicators for important sound events
- **Control Remapping**: Full customization of controls
- **Motion Sensitivity**: Adjustable camera movement options
- **Contrast Settings**: Enhanced visibility options for UI elements
