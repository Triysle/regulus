# REGULUS FPS: GAME OVERVIEW

## 1. VISION STATEMENT

Regulus is a team-based first-person shooter set on a vibrant alien world featuring a three-faction conflict over a powerful resource called Ʉnobtainium. The game combines persistent territorial warfare with resource management, construction, and squad-based coordination in a stylized, accessible visual style built in Godot 4.

## 2. KEY DIFFERENTIATORS

- **Persistent Three-Faction Conflict**: A dynamic, ongoing war between three balanced but visually distinct factions
- **Team-Based Command Structure**: Organized leadership roles with specialized abilities
- **Resource-Driven Strategy**: Collection and strategic allocation of Ʉnobtainium to power gameplay
- **Higher Time-to-Kill**: Combat that rewards tactical decision-making over twitch reflexes
- **Construction System**: Player-built fortifications and facilities that influence battlefield control
- **Stylized Visual Approach**: Low-poly art direction with vibrant colors and distinct silhouettes

## 3. TARGET EXPERIENCE

- **Player Count**: 99 players (33 per faction) battling across connected areas
- **Session Length**: 1-3 hours of gameplay with persistent progress between sessions
- **Engagement Loop**: Territory control → Resource acquisition → Equipment/Construction → Combat advantage
- **Playstyle Balance**: Support for combat, logistics, leadership, and construction specializations
- **Accessibility**: Intuitive mechanics with depth for strategic players

## 4. SETTING & NARRATIVE

Regulus is a resource-rich exoplanet discovered in the mid-23rd century, notable for its deposits of Ʉnobtainium - a semi-crystalline material with remarkable properties:
- Can be programmed at the molecular level to transform into almost any material
- Functions as an incredibly efficient energy source when refined
- Emits a soft blue glow that intensifies when disturbed

Following Earth's economic and political collapse, three major factions emerged on Regulus:

- **The Meridian Corporation**: Corporate remnants with a hierarchical structure focused on technological progress and profit
- **The Coalition of Free Miners**: A democratic labor movement valuing individual freedom and collective support
- **The Luminous Path**: A quasi-religious research collective that believes Ʉnobtainium is a gateway to higher consciousness

The narrative tone maintains a lighthearted frontier adventure with elements of corporate intrigue and occasional absurdist humor.

## 5. CORE GAMEPLAY SYSTEMS

### 5.1 Combat System
- Shield/armor/health defensive layers with different regeneration mechanics
- Three main weapon categories: kinetic, energy, and explosive
- Combined-arms approach with infantry and vehicles
- Higher time-to-kill (TTK) similar to Halo

### 5.2 Resource System
- Ʉnobtainium as the universal resource currency
- Collection via specialized extraction vehicles
- Nodes with varied size and purity ratings
- Storage and transportation logistics

### 5.3 Construction System
- Structure types: Defensive, Utility, Resource, and Vehicle support
- Foundation-based building on predetermined locations
- Faction-specific visual styles for all structures
- Progressive building process requiring resource contribution

### 5.4 Progression System
- 30-rank advancement structure per faction
- Equipment and capability unlocks through rank progression
- Specialization options for different playstyles
- Optional prestige system for long-term engagement

### 5.5 Squad and Team Mechanics
- Command structure: 1 Commander, 4 Team Leaders, 28 squad members per faction
- Leadership abilities: objective marking, support requisition, tactical coordination
- Communication tools including contextual ping system
- Team benefits encouraging coordinated play

### 5.6 Territory Control
- Hexagonal zone layout with connected regions
- Lattice-based capture system requiring adjacency
- Control Point accumulation as victory condition
- Strategic benefits for territory control

### 5.7 Vehicle System
- Three vehicle classes: Light, Medium, and Heavy frames
- Modular components for customization
- Specialized roles including combat, transport, and resource collection
- Multi-crew operation for team play

## 6. VISUAL DIRECTION

- **Art Style**: Low-poly stylized visuals emphasizing readable silhouettes
- **Color Palette**: Vibrant, distinct faction colors (Meridian: blue/white, Coalition: orange/brown, Luminous: green/purple)
- **Environment Design**: Unique alien biomes with bold visual identities
- **Visual Feedback**: Clear, consistent visual language for gameplay events

## 7. TECHNICAL IMPLEMENTATION

- **Engine**: Built in Godot 4, leveraging improved 3D rendering capabilities
- **Networking**: Client-server architecture with authoritative server
- **Performance Target**: 60fps on mid-range hardware with full 99-player battles
- **Optimization**: Zone-based player distribution, network culling, LOD systems

## 8. DEVELOPMENT APPROACH

Development follows a 5-phase approach:

1. **Phase 1**: Core Combat Mechanics (2 months)
2. **Phase 2**: Multiplayer Foundation (2 months)
3. **Phase 3**: Squad & Objectives (2 months)
4. **Phase 4**: Resource & Construction (1 month)
5. **Phase 5**: Territory & Persistence (5 months)

Each phase builds upon previous work with regular playtest milestones.

## 9. DOCUMENT REFERENCE

This game overview serves as an entry point to the complete Regulus documentation. For detailed information, refer to the following documents:

- **World Building**: world-setting.md, narrative-framework.md
- **Faction Details**: faction-overview.md, faction-meridian.md, faction-coalition.md, faction-luminous.md
- **Game Systems**: system-combat.md, system-resources.md, system-construction.md, system-progression.md, system-squads.md, system-territory.md, system-vehicles.md
- **Technical Documentation**: tech-overview.md, tech-networking.md, tech-performance.md, tech-assets.md
- **User Experience**: ui-design.md, ui-accessibility.md
- **Development**: dev-phases.md, dev-testing.md, dev-risks.md