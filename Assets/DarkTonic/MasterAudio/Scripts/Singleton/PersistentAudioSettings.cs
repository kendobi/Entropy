using UnityEngine;

/// <summary>
/// This class allows you to set defaults that each Master Audio prefab will use during its Start event when the Scene loads up, only if you set the values via code. Useful for setting global SFX and music levels, as well as other more granular settings.
/// </summary>
// ReSharper disable once CheckNamespace
public static class PersistentAudioSettings {
    private const string SfxVolKey = "MA_sfxVolume";
    private const string MusicVolKey = "MA_musicVolume";
    private const string BusVolKey = "MA_BusVolume_";
    private const string GroupVolKey = "MA_GroupVolume_";

    /// <summary>
    /// Sets the bus's volume. During startup (Awake event), the Master Audio prefab will assign any buses that match to the levels you specify here. This will also set the Bus's Volume in the current Scene's Master Audio prefab, if a match exists.
    /// </summary>
    /// <param name="busName">Bus name</param>
    /// <param name="vol">Volume</param>
    public static void SetBusVolume(string busName, float vol) {
        var busKey = MakeBusKey(busName);

        PlayerPrefs.SetFloat(busKey, vol);

        var ma = MasterAudio.SafeInstance;
        if (ma == null) {
            return;
        }
        if (MasterAudio.GrabBusByName(busName) != null) {
            MasterAudio.SetBusVolumeByName(busName, vol);
        }
    }

    private static string MakeBusKey(string busName) {
        return BusVolKey + busName;
    }

    /// <summary>
    /// Gets the bus volume (used by Master Audio prefab during Awake event to set persistent levels).
    /// </summary>
    /// <returns>The group volume.</returns>
    /// <param name="busName">Group name.</param>
    public static float? GetBusVolume(string busName) {
        var busKey = MakeBusKey(busName);

        if (!PlayerPrefs.HasKey(busKey)) {
            return null;
        }

        return PlayerPrefs.GetFloat(busKey);
    }

    private static string GetGroupKey(string groupName) {
        return GroupVolKey + groupName;
    }

    /// <summary>
    /// Sets the group's volume. During startup (Awake event), the Master Audio prefab will assign any Sound Groups that match to the levels you specify here. This will also set the Group's Volume in the current Scene's Master Audio prefab, if a match exists.
    /// </summary>
    /// <param name="grpName">Group name</param>
    /// <param name="vol">Volume</param>
    public static void SetGroupVolume(string grpName, float vol) {
        var groupKey = GetGroupKey(grpName);

        PlayerPrefs.SetFloat(groupKey, vol);

        var ma = MasterAudio.SafeInstance;
        if (ma == null) {
            return;
        }
        if (MasterAudio.GrabGroup(grpName, false) != null) {
            MasterAudio.SetGroupVolume(grpName, vol);
        }
    }

    /// <summary>
    /// Gets the group volume (used by Master Audio prefab during Awake event to set persistent levels).
    /// </summary>
    /// <returns>The group volume.</returns>
    /// <param name="grpName">Group name.</param>
    public static float? GetGroupVolume(string grpName) {
        var groupKey = GetGroupKey(grpName);

        if (!PlayerPrefs.HasKey(groupKey)) {
            return null;
        }

        return PlayerPrefs.GetFloat(groupKey);
    }

    /// <summary>
    /// Gets or sets the persistent Master Mixer Volume value. If this value is set (via code), each Master Audio prefab will read from it and set the Master Mixer Volume to this value, during the Scene's start event. This will also set the Master Mixer Volume in the current Scene's Master Audio prefab, if any.
    /// </summary>
    /// <value>The mixer volume.</value>
    public static float? MixerVolume {
        get {
            if (!PlayerPrefs.HasKey(SfxVolKey)) {
                return null;
            }

            return PlayerPrefs.GetFloat(SfxVolKey);
        }
        set {
            if (!value.HasValue) {
                PlayerPrefs.DeleteKey(SfxVolKey);
                return;
            }

            var newVal = value.Value;
            PlayerPrefs.SetFloat(SfxVolKey, newVal);
            var ma = MasterAudio.SafeInstance;
            if (ma != null) {
                MasterAudio.MasterVolumeLevel = newVal;
            }
        }
    }

    /// <summary>
    /// Gets or sets the Master Playlist Volume. If this value is set, each Master Audio prefab will read from it and set the Master Playlist Volume to this value, during the Scene's start event. This will also set the Master Playlist Volume in the current Scene's Master Audio prefab, if any.
    /// </summary>
    /// <value>The mixer volume.</value>
    public static float? MusicVolume {
        get {
            if (!PlayerPrefs.HasKey(MusicVolKey)) {
                return null;
            }

            return PlayerPrefs.GetFloat(MusicVolKey);
        }
        set {
            if (!value.HasValue) {
                PlayerPrefs.DeleteKey(MusicVolKey);
                return;
            }

            var newVal = value.Value;
            PlayerPrefs.SetFloat(MusicVolKey, newVal);
            var ma = MasterAudio.SafeInstance;
            if (ma != null) {
                MasterAudio.PlaylistMasterVolume = newVal;
            }
        }
    }

    public static void RestoreMasterSettings() {
        if (MixerVolume.HasValue) {
            MasterAudio.MasterVolumeLevel = MixerVolume.Value;
        }

        if (MusicVolume.HasValue) {
            MasterAudio.PlaylistMasterVolume = MusicVolume.Value;
        }
    }
}