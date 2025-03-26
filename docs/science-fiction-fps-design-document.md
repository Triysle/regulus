# Regulus FPS Design Document

## Game Concept

### Setting
A vibrant, stylized alien world focused on control of a valuable resource ("Unobtanium"). The setting features distinct visual environments that work well with low-poly/stylized art direction, emphasizing bold colors and unique silhouettes rather than photorealistic details. The conflict centers around control of this resource which can be used to manufacture almost anything.

The game prioritizes fun gameplay over realism, incorporating fantastical elements like energy weapons, shields, and futuristic technology. The lore maintains a lighthearted tone that provides entertainment while leaving room for players to create their own narratives through gameplay.

### Faction System
- **Number of Factions**: Three distinct factions (similar to Planetside 2)
- **Gameplay Balance**: Functionally symmetric (same capabilities) but visually and thematically distinct
- **Faction Identity**: Each faction has a unique historical background (e.g., one from PMC origins, one from a trade union, one from a religious sect)
- **Resource Usage**: All factions use Unobtanium as a universal currency for gameplay mechanics, but each has different lore motivations for wanting to control it

## Scale and World

### World Persistence
- Persistent world where territory control remains between play sessions
- Player count target of 32 players per faction (96 total concurrent players)
- Visual distinction between biomes without gameplay effects
- Connected but distinct maps/zones that unlock based on battle progression
- Optional visual weather effects without gameplay impact

### Map Structure
- Multiple distinct zones connected in a strategic network
- Factions attempt to win battles in each zone to progress to connecting territories
- Hex-based territory system to allow for dynamic front lines
- Central areas generally more valuable than edges, with some randomization for tactical variety

## Combat Systems

### Weapons and Equipment
- Three main weapon categories: kinetic (bullets), energy (lasers), and explosive (bombs)
- Variety of balanced options for each category across all factions
- Ground vehicles only (no air combat), with possible recon drone abilities
- No fixed classes; equipment uses weight and slot restrictions for customization

### Combat Mechanics
- Higher time-to-kill (TTK) similar to Halo
- Personal shields that recharge after no damage, plus health restored by items/tools
- Simple respawn system with permanent faction base (like Planetside's Warpgates)
- Additional spawn points at controlled territory with appropriate structures

## Squad and Team Mechanics

### Organization Structure
- 32-player faction divided into:
  - 2-person command element
  - Three 10-person teams

### Leadership and Coordination
- Command element can assign teams to map objectives
- Team leaders can mark positions to help team coordination
- Command can call in support (resupply drops, orbital bombardments) based on resources
- Team leaders can request support via ping system

### Communication
- Ping system for core coordination
- Players can use external voice/text solutions (Discord, etc.)
- Rewards for following marked objectives and responding to support requests

## Territory Control and Strategy

### Capture Mechanics
- Inspired by Albion Online's faction warfare
- Strategic objectives increase rate of zone capture when controlled
- Different outposts have varied capture criteria (like Helldivers' diverse missions)

### Strategic Benefits
- Economic benefits (gear/vehicle discounts)
- Faster cooldowns on support calls
- Increased resource generation or XP boosts

### Resource Distribution
- Higher value in map centers and edges between bases
- Randomization of specific values each time a zone becomes active
- Prefab-based construction system for resource production, defenses, and forward bases

### Territory Permanence
- Maps lock for a period after capture
- Only contestable when on the current front line
- Hex-based system for dynamic territory changes

## Progression Systems

### Individual Progression
- Rank system with unique names/iconography but identical progression criteria across factions
- Equipment gradually unlocks as players rank up
- Focus on variety and options rather than direct power increases
- Personal progress persists between sessions with potential prestige/seasonal resets

### Faction Progression
- Territory-based progression
- Increased maintenance costs as territory expands (preventing easy domination)
- Potential long-term campaigns with cosmetic rewards for winning factions

## User Interface

### HUD Elements
- Health/shields, weapon/ammo, and item/ability indicators (bottom left)
- Minimap (bottom right) for local orientation
- Larger map overlay (M key) for strategic view
- Objective markers visible in-world based on team/command assignments
- Support for colorblind accessibility options

## Technical Implementation

### Networking
- Dedicated server architecture
- Focus on optimizing for 96 concurrent players
- Connected but separate maps to manage player distribution

### Development Approach
- Built in Godot 4
- Leveraging improved 3D rendering for stylized visuals
- Using prefab-based construction system
- Level-of-detail optimization for distant objects
- Network culling for entities outside player relevance

### Data Persistence
- Database storage for critical world state
- Focus on essential data (territory control, structure locations)
- Regular automated backups

# Prototyping Plan

## Phase 1: Core Combat Mechanics (Months 1-2)

### Basic Movement and Controls
- First-person character controller implementation
- Movement, jumping, and crouching mechanics
- Environment collision detection
- Testing different movement speeds and jump heights

### Weapon Systems
- One weapon prototype from each category (kinetic, energy, explosive)
- Shield/health system with recharge mechanics
- Time-to-kill balancing
- Visual and audio feedback for combat actions

### Simple Environment
- Small test arena with basic cover elements
- Scale testing for appropriate play spaces
- Performance testing with low-poly assets

## Phase 2: Basic Multiplayer Functionality (Months 3-4)

### Networking Fundamentals
- Client-server architecture setup
- Player synchronization across network
- Small-scale testing (2-4 players)
- Basic latency compensation

### Expanded Combat Testing
- Full weapon type implementation with preliminary balancing
- Hitbox detection and damage calculations
- Multi-player combat scenarios

### UI Elements
- Core HUD implementation
- Map overlay functionality
- UI scaling and readability testing

## Phase 3: Squad Mechanics and Objectives (Months 5-6)

### Squad System
- Squad formation mechanics
- Team leader marking tools
- Ping system implementation

### Simple Objectives
- Capture point mechanics
- Visual objective status indicators
- Reward system for objective completion

### Command Structure
- Commander role implementation
- Objective assignment system
- Team reward tracking for following assignments

## Phase 4: Resource and Construction Systems (Month 7)

### Resource Collection
- Resource node implementation
- Gathering mechanics
- Basic inventory system

### Basic Construction
- 2-3 structure types with distinct functions
- Prefab-based construction system
- Testing structure impact on gameplay flow

### Support Abilities
- Commander support call mechanics
- Resource cost implementation
- Balance testing for strategic impact

## Phase 5: Territory Control and Persistence (Months 8-12)

### Multi-Zone Maps
- Small system of 2-3 connected zones
- Zone transition mechanics
- Capture progression implementation

### Faction Systems
- Faction selection implementation
- Faction-specific visual elements
- Balance testing across objectives

### Persistence Layer
- Database implementation for world state
- Session-to-session persistence
- Data integrity and recovery testing

## Testing Strategy

### Scaling Approach
- Begin with very small player counts (2-4)
- Gradually increase as systems stabilize
- Use automated testing where possible

### Focused Test Sessions
- Scheduled specific testing sessions
- Feature-focused testing
- Structured feedback collection

### Progressive Expansion
- Start with single small map
- Expand to simple multi-zone system
- Scale only when smaller systems are stable

### Community Development
- Recruit dedicated testers
- Create testing communication channels
- Use recorded gameplay for analysis

## Technical Learning Priorities

### Networking
- Godot High-Level Multiplayer API fundamentals
- Simple multiplayer prototype practice
- Server-authoritative architecture understanding

### Scene Management
- Modular scene structure
- Optimized loading/unloading
- Instancing system for prefabs

### Data Persistence
- Save/load system implementation
- Database interfacing (starting with SQLite)
- Game state serialization techniques
