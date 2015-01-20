//Version=1.0
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

[CustomEditor(typeof(UNOShaderHelper)),CanEditMultipleObjects]

public class UNOShaderHelper_Editor : Editor
{
	UNOShaderHelper ST;
	bool inspect;
	
	void OnEnable()
	{
		ST = target as UNOShaderHelper;
	}
	
	public override void OnInspectorGUI() 
	{
		ST.UpdateValues();
		inspect = EditorGUILayout.ToggleLeft ("Inspect", inspect);
		if(inspect)
		{
			DrawDefaultInspector();
		}
	}
}