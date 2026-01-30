/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Audiokinetic Wwise generated include file. Do not edit.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef __WWISE_IDS_H__
#define __WWISE_IDS_H__

#include <AK/SoundEngine/Common/AkTypes.h>

namespace AK
{
    namespace EVENTS
    {
        static const AkUniqueID BGM_EVENT = 1799075776U;
        static const AkUniqueID DOLL_EVENT = 374202415U;
        static const AkUniqueID FOOTSTEP_SFX_EVENT = 1544508818U;
        static const AkUniqueID PLAYER_BODY_SFX_EVENT = 3353559196U;
        static const AkUniqueID PLAYER_INFO_SFX_EVENT = 2438554864U;
        static const AkUniqueID SFX_AMBIENT_EVENT = 3561112890U;
        static const AkUniqueID SFX_WORLD_EVENT = 190124326U;
        static const AkUniqueID UI_EVENT = 223084590U;
    } // namespace EVENTS

    namespace SWITCHES
    {
        namespace BGM_SWITCH
        {
            static const AkUniqueID GROUP = 1239043692U;

            namespace SWITCH
            {
                static const AkUniqueID BGM_01 = 3935703657U;
                static const AkUniqueID BGM_02 = 3935703658U;
                static const AkUniqueID BGM_03 = 3935703659U;
            } // namespace SWITCH
        } // namespace BGM_SWITCH

        namespace JUMP_SWITCH
        {
            static const AkUniqueID GROUP = 30733176U;

            namespace SWITCH
            {
                static const AkUniqueID JUMP = 3833651337U;
                static const AkUniqueID LAND = 674522502U;
            } // namespace SWITCH
        } // namespace JUMP_SWITCH

        namespace MATERIAL_FOOT_SWITCH
        {
            static const AkUniqueID GROUP = 3395398704U;

            namespace SWITCH
            {
                static const AkUniqueID ROCK = 2144363834U;
                static const AkUniqueID TILE = 2637588553U;
            } // namespace SWITCH
        } // namespace MATERIAL_FOOT_SWITCH

        namespace MOVE_SPEED_SWITCH
        {
            static const AkUniqueID GROUP = 3336837497U;

            namespace SWITCH
            {
                static const AkUniqueID JUMP = 3833651337U;
                static const AkUniqueID RUN = 712161704U;
                static const AkUniqueID WALK = 2108779966U;
            } // namespace SWITCH
        } // namespace MOVE_SPEED_SWITCH

        namespace PLAYER_BODY_SFX
        {
            static const AkUniqueID GROUP = 3398093513U;

            namespace SWITCH
            {
                static const AkUniqueID HURT = 3193947170U;
                static const AkUniqueID JUMP = 3833651337U;
            } // namespace SWITCH
        } // namespace PLAYER_BODY_SFX

        namespace SFX_AMBIENT_SWITCH
        {
            static const AkUniqueID GROUP = 2894110654U;

            namespace SWITCH
            {
                static const AkUniqueID INTERIOR_HUM = 1014142962U;
            } // namespace SWITCH
        } // namespace SFX_AMBIENT_SWITCH

        namespace SFX_WORLD_SWITCH
        {
            static const AkUniqueID GROUP = 3015996730U;

            namespace SWITCH
            {
                static const AkUniqueID LIGHT_HUM = 3929635500U;
                static const AkUniqueID STATIC = 1409504247U;
            } // namespace SWITCH
        } // namespace SFX_WORLD_SWITCH

        namespace UI_SFX
        {
            static const AkUniqueID GROUP = 3563481019U;

            namespace SWITCH
            {
                static const AkUniqueID UI_CANCEL = 3083016892U;
                static const AkUniqueID UI_CLOSE = 2519197294U;
                static const AkUniqueID UI_OPEN = 3282376362U;
                static const AkUniqueID UI_POPUP = 318623688U;
                static const AkUniqueID UI_SELECT = 2774129122U;
            } // namespace SWITCH
        } // namespace UI_SFX

    } // namespace SWITCHES

    namespace GAME_PARAMETERS
    {
        static const AkUniqueID DISTORTION = 1517463400U;
        static const AkUniqueID TIME_STRETCH = 1111219968U;
    } // namespace GAME_PARAMETERS

    namespace BANKS
    {
        static const AkUniqueID INIT = 1355168291U;
        static const AkUniqueID EVENTS_BGM = 3487751677U;
        static const AkUniqueID EVENTS_ENEMIES = 3689319643U;
        static const AkUniqueID EVENTS_PLAYER = 1597557594U;
        static const AkUniqueID EVENTS_UI = 32930471U;
        static const AkUniqueID EVENTS_WORLD = 1906124703U;
    } // namespace BANKS

    namespace BUSSES
    {
        static const AkUniqueID MAIN_AUDIO_BUS = 2246998526U;
    } // namespace BUSSES

    namespace AUDIO_DEVICES
    {
        static const AkUniqueID NO_OUTPUT = 2317455096U;
        static const AkUniqueID SYSTEM = 3859886410U;
    } // namespace AUDIO_DEVICES

}// namespace AK

#endif // __WWISE_IDS_H__
