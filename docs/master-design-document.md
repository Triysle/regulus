# REGULUS FPS - MASTER DESIGN DOCUMENT

## DOCUMENT PURPOSE
This master document serves as the central reference point for the Regulus FPS project. It provides a high-level overview of all major systems and references the detailed documentation for each component.

---

## GAME CONCEPT

### Core Premise
Regulus is a team-based first-person shooter set on a vibrant alien world where three distinct factions battle for control of a valuable resource called Ʉnobtainium. The game features territorial conquest, strategic resource management, and team-based coordination in a persistent online world.

### Key Differentiators
- **Persistent World**: Territory control persists between sessions
- **Three-Faction Conflict**: Dynamic multi-sided warfare (similar to Planetside)
- **Team-Based Gameplay**: Structured roles with leadership positions
- **Resource-Driven Gameplay**: Collection and strategic use of Ʉnobtainium
- **Construction System**: Build and fortify strategic positions
- **High Time-to-Kill**: Combat emphasizes tactical decisions over twitch reflexes

### Target Experience
- 99 players (33 per faction) battling across connected zones
- Session length of 1-3 hours with persistent progression
- Accessible mechanics with strategic depth
- Emphasis on teamwork and coordination

### Setting & Tone
A stylized alien planet with distinct visual environments, emphasizing vibrant colors and unique silhouettes over photorealism. The narrative maintains a lighthearted tone that provides context without dominating the player experience.

---

## DOCUMENTATION STRUCTURE

| Document | Purpose | Key Content |
|----------|---------|-------------|
| [Game Systems Design](/reference/regulus-game-systems.md) | Detailed gameplay mechanics | Combat, resources, construction, progression |
| [Technical Design](/reference/streamlined-tdd.md) | Implementation architecture | Technology stack, networking, performance |
| [Narrative Bible](/reference/regulus-narrative.md) | World and story | Setting, factions, characters, lore |
| [Faction Guide](/reference/regulus-faction-lore.md) | Faction-specific details | Visual identity, philosophy, playstyle |
| [Progression System](/reference/regulus-faction-ranks.md) | Player advancement | Rank structure, unlocks, rewards |

---

## FACTIONS

Regulus features three distinct factions, each with unique visual identity and narrative background while maintaining balanced gameplay capabilities.

### The Meridian Corporation
- **Origins**: Corporate security forces that merged after Earth's collapse
- **Structure**: Hierarchical with clear chain of command
- **Ideology**: Technological progress and profit-driven efficiency
- **Aesthetic**: Clean, angular designs with blue and white color scheme
- **Key Character**: Director Eliza Vex

### The Coalition of Free Miners
- **Origins**: Labor movement that refused corporate control
- **Structure**: Democratic with elected representatives
- **Ideology**: Individual freedom and collective support
- **Aesthetic**: Practical, rugged designs with orange and brown color scheme
- **Key Character**: Foreman Jace Redrock

### The Luminous Path
- **Origins**: Research collective studying Ʉnobtainium's effects on consciousness
- **Structure**: Communal, guided by council of "Enlightened"
- **Ideology**: Ʉnobtainium as gateway to higher consciousness
- **Aesthetic**: Organic, flowing designs with green and purple color scheme
- **Key Character**: Oracle Sera Lumen

---

## CORE GAMEPLAY SYSTEMS

### Combat System
- **Time-to-Kill**: Higher TTK similar to Halo
- **Defensive Layers**: Shields (regenerate), Armor (equipment), Health (items/stations)
- **Weapon Categories**: Kinetic, Energy, Explosive
- **Damage Types**: Different effectiveness against shields, armor, and health

→ [Detailed Combat System Documentation](/reference/regulus-game-systems.md#1-combat-mechanics)

### Resource System
- **Primary Resource**: Ʉnobtainium (Ʉ)
- **Collection Method**: Specialized vehicles extract from resource nodes
- **Usage**: Construction, equipment, vehicles, support abilities

→ [Detailed Resource System Documentation](/reference/regulus-game-systems.md#2-resource-system)

### Construction System
- **Structure Types**: Defensive, Utility, Resource, Vehicle
- **Foundation System**: Pre-placed building locations
- **Building Process**: Blueprint selection, resource contribution, construction

→ [Detailed Construction System Documentation](/reference/regulus-game-systems.md#3-construction-system)

### Player Progression
- **Rank Structure**: 30-rank system per faction
- **XP Sources**: Objectives, combat, support, following orders
- **Unlocks**: Weapons, vehicles, structures, equipment options
- **Prestige System**: Optional rank reset with permanent benefits

→ [Detailed Progression System Documentation](/reference/regulus-game-systems.md#4-player-progression-system)

### Team Structure
- **Players Per Faction**: 33 players
- **Organization**: 1 Commander, 4 Teams of 8 players each (1 Team Leader + 7 members)
- **Leadership Abilities**: Marking objectives, requesting support, strategic coordination

→ [Detailed Team System Documentation](/reference/regulus-game-systems.md#5-squad-and-team-systems)

### Territory Control
- **Zone Layout**: Hexagonal zones with bases and outposts
- **Capture Mechanics**: Lattice-based control system
- **Victory Condition**: First faction to reach 100 Control Points
- **Strategic Benefits**: Resource production, spawn options, equipment access

→ [Detailed Territory Control Documentation](/reference/regulus-game-systems.md#6-territory-control-system)

### Vehicle System
- **Vehicle Types**: Light, Medium, Heavy frames
- **Customization**: Modular weapons and utility systems
- **Acquisition**: Spawned at garage structures for Ʉ cost

→ [Detailed Vehicle System Documentation](/reference/regulus-game-systems.md#7-vehicle-systems)

---

## USER INTERFACE

### HUD Elements
- **Player Status**: Shield/armor/health bars (bottom left)
- **Weapon Info**: Ammo counts and equipment status (bottom left)
- **Minimap**: Local tactical information (bottom right)
- **Territory Control**: Faction progress bars (top center)
- **Team Status**: Squad member info and objectives (top left)

→ [Detailed UI Documentation](/reference/regulus-game-systems.md#8-user-interface-and-player-experience)

---

## TECHNICAL OVERVIEW

### Technology Stack
- **Engine**: Godot 4.x
- **Networking**: Godot's High-Level Multiplayer API with ENet
- **Database**: SQLite for local, PostgreSQL for server

### Architecture
- Component-based architecture with clear system separation
- Client-server model with authoritative server
- Interest-based network culling for performance

→ [Detailed Technical Documentation](/reference/streamlined-tdd.md)

---

## DEVELOPMENT ROADMAP

### Phase 1: Core Combat Mechanics (2 months)
- Basic movement and controls
- Weapon systems prototype
- Simple environment testing

### Phase 2: Multiplayer Foundation (2 months)
- Networking fundamentals
- Expanded combat testing
- UI elements implementation

### Phase 3: Squad & Objectives (2 months)
- Squad system implementation
- Capture mechanics
- Command structure

### Phase 4: Resource & Construction (1 month)
- Resource collection
- Construction system
- Support abilities

### Phase 5: Territory & Persistence (5 months)
- Multi-zone maps
- Faction systems
- Persistence layer
- Scaling and optimization

---

## RISK ASSESSMENT

### Technical Challenges
- **Player Count**: Maintaining performance with 99 concurrent players
- **Networking**: Balancing responsiveness and bandwidth usage
- **World Persistence**: Database management for territory state

### Design Challenges
- **Faction Balance**: Maintaining equilibrium in three-faction warfare
- **New Player Experience**: Accessibility for players joining ongoing conflicts
- **Team Coordination**: Encouraging structured play without strict enforcement

### Mitigation Strategies
- Phased development with regular playtesting
- Scalable systems that work with varying player counts
- Progressive complexity introduction through tutorial systems

---

## REFERENCES & INSPIRATION

### Games
- **Planetside 2**: Faction warfare and territory control
- **Halo**: Combat feel and time-to-kill
- **Foxhole**: Persistent warfare and resource logistics
- **Helldivers**: Mission variety and team coordination

### Art & Setting
- Low-poly stylized visuals with distinct faction aesthetics
- Vibrant alien environments with unique biomes
- Functional design language consistent with faction identities
