using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;

public class CloudInspector : MaterialEditor {

	public override void OnInspectorGUI (){
		if(isVisible){
			base.OnInspectorGUI();
			Material targetMat = (Material)target;
			string[] keyWords = targetMat.shaderKeywords;

			bool depthBlend = keyWords.Contains ("DEPTHBLEND_ON");
			bool computeLighting = keyWords.Contains ("LIGHTING_ON");
			bool horizonBlend = keyWords.Contains ("HORIZONBLEND_ON");
			bool normalized = keyWords.Contains ("NORMALIZED_ON");
			EditorGUI.BeginChangeCheck();
			depthBlend = EditorGUILayout.Toggle ("DepthBlend", depthBlend);
			horizonBlend = EditorGUILayout.Toggle ("Blend At Edges", horizonBlend);
			computeLighting = EditorGUILayout.Toggle ("Complex Lighting", computeLighting);
			if(computeLighting)normalized = EditorGUILayout.Toggle ("Normalized Lighting", normalized);
			if (EditorGUI.EndChangeCheck()){
				List<string> keywords = new List<string> {
					depthBlend ? "DEPTHBLEND_ON" : "DEPTHBLEND_OFF",
					computeLighting ? "LIGHTING_ON" : "LIGHTING_OFF",
					horizonBlend ? "HORIZONBLEND_ON" : "HORIZONBLEND_OFF",
					normalized ? "NORMALIZED_ON" : "NORMALIZED_OFF"
				};
				targetMat.shaderKeywords = keywords.ToArray();
				EditorUtility.SetDirty (targetMat);

			}
		}



	}
}
