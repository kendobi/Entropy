using System;

[Serializable]
// ReSharper disable once CheckNamespace
public class BusFadeInfo  {
	public string NameOfBus;
	public GroupBus ActingBus;
	public float TargetVolume;
	public float VolumeStep;
	public bool IsActive = true;
    // ReSharper disable once InconsistentNaming
    public System.Action completionAction;
}
