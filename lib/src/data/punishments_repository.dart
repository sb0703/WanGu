import 'dart:math';
import '../models/player.dart';
import '../models/item.dart';
import '../models/punishment_result.dart';

class PunishmentsRepository {
  static PunishmentResult applyPunishment({
    required Player player,
    required int maxXp,
    required bool isMajorBreakthrough,
    required Random rng,
  }) {
    // Default penalty: Lose XP
    int penaltyXp = (maxXp * 0.3).toInt();
    String message = isMajorBreakthrough
        ? '破境失败，心魔反噬！\n修为损失 $penaltyXp'
        : '突破失败，气息紊乱。\n修为损失 $penaltyXp';
    
    // Punishment Logic based on Purity and Randomness
    final purity = player.stats.purity;
    final roll = rng.nextDouble();
    
    Player newPlayer = player;
    String logMessage = '';
    int daysPassed = 0;
    bool teleportToDanger = false;
    bool spawnNemesis = false;

    // 1. Severe Punishment (Body Horror / Soul Damage / Permanent Changes)
    // Trigger if Purity < 40% AND roll < 0.3 (30% chance)
    if (purity < 40 && roll < 0.3) {
       // 5 Types: Limb, Blind, Beast, Gender, Dao Heart
       final severeRoll = rng.nextInt(5);
       
       if (severeRoll == 0) {
         // Limb Loss (Attack reduced)
         if (!player.buffIds.contains('missing_limb')) {
            newPlayer = player.copyWith(
              buffIds: [...player.buffIds, 'missing_limb'],
              // Stats handled by buff
              xp: (player.xp - penaltyXp).clamp(0, maxXp),
            );
            message = '【肉身残缺】雷劫落下，你下意识抵挡。\n烟消云散后，你空荡荡的袖管随风飘荡。\n攻击力大幅下降！';
            logMessage = '突破惨败！遭遇雷劫轰击，痛失一臂！';
         } else {
            // Fallback
            newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
            logMessage = '突破失败，旧伤复发。';
         }
       } else if (severeRoll == 1) {
         // Sensory Deprivation (Blindness)
         if (!player.buffIds.contains('blind')) {
            newPlayer = player.copyWith(
              buffIds: [...player.buffIds, 'blind'],
              // Stats handled by buff
              xp: (player.xp - penaltyXp).clamp(0, maxXp),
            );
            message = '【五感尽失】双目突然刺痛流血，眼前世界归于黑暗。\n你虽有修为，此刻却如盲人摸象。\n悟性大幅下降！';
            logMessage = '突破惨败！双目失明，神识受损！';
         } else {
             newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
             logMessage = '突破失败，旧伤复发。';
         }
       } else if (severeRoll == 2) {
         // Bestial Regression (Beast Form)
         if (!player.buffIds.contains('beast_form')) {
            newPlayer = player.copyWith(
              buffIds: [...player.buffIds, 'beast_form'],
              // Stats handled by buff
              xp: (player.xp - penaltyXp).clamp(0, maxXp),
            );
            message = '【半妖化】灵气失控激活了你血脉中潜藏的兽性。\n手臂长出鳞片，喉咙发出嘶吼。\n攻击/速度上升，悟性/灵力下降！';
            logMessage = '突破惨败！血脉逆行，化为半妖！';
         } else {
             newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
             logMessage = '突破失败，兽性大发。';
         }
       } else if (severeRoll == 3) {
         // Gender Bender (Yin Yang Reversal)
         final newGender = player.gender == '男' ? '女' : '男';
         newPlayer = player.copyWith(
           gender: newGender,
           buffIds: [...player.buffIds, 'yin_yang_reversal'], // Add buff for flavor/tracking
           xp: (player.xp - penaltyXp).clamp(0, maxXp),
         );
         message = '【阴阳逆转】阴阳二气在体内乱窜，重塑了你的肉身。\n你惊讶地发现声音变了，身体特征也发生了翻天覆地的变化。\n你变成了$newGender性！';
         logMessage = '突破惨败！阴阳逆转，变为$newGender儿身！';
       } else {
         // Dao Heart Broken
          if (!player.buffIds.contains('broken_dao')) {
            newPlayer = player.copyWith(
              buffIds: [...player.buffIds, 'broken_dao'],
              // Stats handled by buff
              xp: (player.xp - penaltyXp).clamp(0, maxXp),
            );
            message = '【道心破碎】脑海中一片空白。\n你明明记得功法口诀，身体却僵硬得像块木头。\n悟性永久降低！';
            logMessage = '突破惨败！心魔入侵，道心破碎！';
         } else {
             newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
             logMessage = '突破失败，心魔难除。';
         }
       }
    } 
    // 2. Medium Punishment (Resource / Social / Environment)
    // Trigger if Purity < 70% AND roll < 0.5
    else if (purity < 70 && roll < 0.5) {
       final mediumRoll = rng.nextInt(10); // 10 types
       
       if (mediumRoll == 0) {
         // Time Skip (Lifespan loss)
         final lostYears = 60;
         daysPassed = lostYears * 365;
         newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
         message = '【枯坐甲子】这一觉睡得太久。\n醒来时，洞府外的树苗已长成参天大树。\n寿元减少 $lostYears 年！';
         logMessage = '突破失败，陷入沉睡六十载，沧海桑田！';
       } else if (mediumRoll == 1) {
         // Inventory Loss (Bag Explode)
         if (player.inventory.isNotEmpty) {
           final lostCount = max(1, (player.inventory.length * 0.3).toInt());
           final newInventory = [...player.inventory];
           final lostItems = <String>[];
           for (int i = 0; i < lostCount; i++) {
             if (newInventory.isNotEmpty) {
               final index = rng.nextInt(newInventory.length);
               lostItems.add(newInventory[index].name);
               newInventory.removeAt(index);
             }
           }
           newPlayer = player.copyWith(
             inventory: newInventory,
             xp: (player.xp - penaltyXp).clamp(0, maxXp),
           );
           message = '【储物袋炸裂】突破引发的空间震荡波及了储物袋。\n你积攒的资源化为齑粉。\n损失：${lostItems.join(', ')}';
           logMessage = '突破失败，空间震荡，损失物品：${lostItems.join(', ')}';
         } else {
           newPlayer = player.copyWith(xp: 0);
           message = '【修为散尽】突破失败，气海崩塌。\n你辛苦积攒的修为付诸东流。';
           logMessage = '突破失败，修为散尽。';
         }
       } else if (mediumRoll == 2) {
         // Artifact Rebellion (Unequip Weapon)
         final weapon = player.equipped.firstWhere(
           (e) => e.type == ItemType.equipment && e.slot == EquipmentSlot.mainHand,
           orElse: () => Item(id: 'none', name: 'None', type: ItemType.other, description: ''),
         );
         if (weapon.id != 'none') {
             final newEquipped = player.equipped.where((e) => e != weapon).toList();
             final newInventory = [...player.inventory, weapon]; // Return to inventory
             newPlayer = player.copyWith(
                equipped: newEquipped,
                inventory: newInventory,
                xp: (player.xp - penaltyXp).clamp(0, maxXp),
             );
             message = '【本命法宝反噬】剑灵感受到了你的软弱与失败，发出一声悲鸣，自行封印。\n它拒绝再为你而战！';
             logMessage = '突破失败，法宝反噬，解除装备。';
         } else {
             newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
             message = '【器灵嘲笑】你两手空空，连个法宝都没有，脑海中传来一阵嘲笑声。\n精神受到暴击！';
             logMessage = '突破失败，被器灵嘲笑。';
         }
       } else if (mediumRoll == 3) {
         // Base Destruction
         newPlayer = player.copyWith(
           stats: player.stats.copyWith(spirit: 0),
           xp: (player.xp - penaltyXp).clamp(0, maxXp),
         );
         message = '【洞府坍塌】轰隆！你所在的洞府承受不住狂暴的灵压，彻底崩塌。\n废墟之中，聚灵阵损毁，灵力枯竭！';
         logMessage = '突破失败，炸毁洞府。';
       } else if (mediumRoll == 4) {
         // Follower Betrayal (Loss of items, similar to Inventory Loss but distinct text)
         if (player.inventory.isNotEmpty) {
           final lostCount = max(1, (player.inventory.length * 0.2).toInt());
           final newInventory = [...player.inventory];
           final lostItems = <String>[];
           for (int i = 0; i < lostCount; i++) {
             if (newInventory.isNotEmpty) {
               final index = rng.nextInt(newInventory.length);
               lostItems.add(newInventory[index].name);
               newInventory.removeAt(index);
             }
           }
           newPlayer = player.copyWith(
             inventory: newInventory,
             xp: (player.xp - penaltyXp).clamp(0, maxXp),
           );
           message = '【树倒猢狲散】见你渡劫失败，气息奄奄。\n你那平日里恭敬的劣徒卷走了你的物资跑路！\n损失：${lostItems.join(', ')}';
           logMessage = '突破失败，遭徒弟背叛，损失物品：${lostItems.join(', ')}';
         } else {
            newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
            message = '【众叛亲离】你身边空无一物，弟子们见你失败，纷纷作鸟兽散。';
            logMessage = '突破失败，弟子跑路。';
         }
       } else if (mediumRoll == 5) {
         // Divorce
         newPlayer = player.copyWith(
           stats: player.stats.copyWith(spirit: 0), // Mental damage
           xp: (player.xp - penaltyXp).clamp(0, maxXp),
         );
         message = '【道侣断义】那人看着浑身焦黑的你，叹了一口气：\n“大道无情，你我仙凡有别，缘分已尽。”\n说完，对方转身离去，你道心受损，灵力溃散。';
         logMessage = '突破失败，惨遭抛弃。';
       } else if (mediumRoll == 6) {
         // Nemesis Alert
         spawnNemesis = true;
         newPlayer = player.copyWith(
             buffIds: [...player.buffIds, 'nemesis_lock'], // Add nemesis lock buff
             xp: (player.xp - penaltyXp).clamp(0, maxXp)
         );
         message = '【仇家锁定】你的护体金光破碎，气息外泄。\n方圆百里的修士都感应到了这里有一只“肥羊”刚刚渡劫失败。\n仇家正在逼近！';
         logMessage = '突破失败，引来仇家！';
       } else if (mediumRoll == 7) {
         // Void Banishment
         teleportToDanger = true;
         if (!player.buffIds.contains('void_sickness')) {
             newPlayer = player.copyWith(
               buffIds: [...player.buffIds, 'void_sickness'],
               // Stats handled by buff
               xp: (player.xp - penaltyXp).clamp(0, maxXp),
             );
         } else {
             newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
         }
         message = '【虚空流放】突破失败撕裂空间，你被吸入虚空裂缝！\n再次睁眼，四周是一片死寂的灰雾，危险的气息让你战栗。\n你迷路了，且染上了虚空之疾。';
         logMessage = '突破失败，流放虚空！';
       } else if (mediumRoll == 8) {
         // Cursed Atmosphere
         if (!player.buffIds.contains('cursed_land')) {
             newPlayer = player.copyWith(
               buffIds: [...player.buffIds, 'cursed_land'],
               xp: (player.xp - penaltyXp).clamp(0, maxXp),
             );
             message = '【天罚力场】因为你的逆天之举，天道锁死了这片区域的灵气。\n你感到呼吸困难，修炼将变得异常艰难！';
             logMessage = '突破失败，天降诅咒。';
         } else {
             newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
             logMessage = '突破失败，天罚加重。';
         }
       } else {
         // Karma Debt
         if (!player.buffIds.contains('karma_debt')) {
             newPlayer = player.copyWith(
               buffIds: [...player.buffIds, 'karma_debt'],
               xp: (player.xp - penaltyXp).clamp(0, maxXp),
             );
             message = '【因果缠身】为了在雷劫中活下来，你在恍惚中与某个不可名状的存在签订了契约。\n现在，讨债的时刻倒计时开始了。';
             logMessage = '突破失败，欠下因果。';
         } else {
             newPlayer = player.copyWith(xp: (player.xp - penaltyXp).clamp(0, maxXp));
             logMessage = '突破失败，因果加深。';
         }
       }
    } 
    // 3. Light Punishment (Standard XP Loss + HP Damage + Minor Afflictions)
    else {
      // Standard XP penalty
      // Add 'soul_parasite' chance (20%)
      if (rng.nextDouble() < 0.2 && !player.buffIds.contains('soul_parasite')) {
          newPlayer = player.copyWith(
            buffIds: [...player.buffIds, 'soul_parasite'],
            xp: (player.xp - penaltyXp).clamp(0, maxXp),
            stats: player.stats.copyWith(hp: 1),
          );
          message = '【识海寄生】你感觉脖子后面凉飕飕的。\n域外天魔趁虚而入，寄生在你体内。\n修炼收益将大幅降低！';
          logMessage = '突破失败，天魔入体！';
      } else {
          newPlayer = player.copyWith(
            xp: (player.xp - penaltyXp).clamp(0, maxXp),
            // Heavy damage
            stats: player.stats.copyWith(hp: 1),
          );
          message += '\n身受重伤，气若游丝。';
          logMessage = '突破失败，元气大伤。';
      }
    }
    
    return PunishmentResult(
      player: newPlayer,
      message: message,
      logMessage: logMessage,
      daysPassed: daysPassed,
      teleportToDanger: teleportToDanger,
      spawnNemesis: spawnNemesis,
    );
  }
}
